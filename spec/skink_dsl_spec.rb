require_relative './spec_helper'

shared_examples "a REST API test language" do
  it "is able to test a HEAD" do
    head "/"
    response.should have_status_code 200
    response.body.size.should == 0
  end

  it "has a helpful failure message for have_status_code" do
    head "/"
    expect { response.should have_status_code 500 }.to raise_error("expected status code 500, but got 200")
    expect { response.should_not have_status_code 200 }.to raise_error("expected status code would not be 200, but dang, it was")
  end

  it "is able to test a GET" do
    get "/"
    response.should have_status_code 200
    response.body.should == "Hello, world!"
  end

  it "is able to test a POST" do
    body = "<ping/>"
    with_content_type_header "application/xml"
    post "/", body
    response.should have_status_code 200
    response.body.should == body
  end

  it "is able to test a PUT" do
    body = "{\"ping\": \"hello\"}"
    with_content_type_header "application/json"
    put "/", body
    response.should have_status_code 200
    response.body.should == body
  end

  it "is able to test a DELETE" do
    delete "/"
    response.should have_status_code 200
    response.body.should == "Deleted"
  end

  it "is able to test a request with additional headers" do
    with_accept_header "application/json"
    get "/foo"
    response.should have_status_code 200
    response.body.should == "{\"foo\": 42}"
  end

  it "is able to test requests which require basic authentication" do
    with_basic_auth "admin", "admin"
    get "/protected"
    response.should have_status_code 200
    response.body.should == "Welcome, authenticated client."
  end

  it "is able to test requests which require basic authentication for specified realm" do
    get "/protected"
    response.should have_status_code 401

    with_basic_auth "admin", "admin", "Restricted Area"
    get "/protected"
    response.should have_status_code 200
    response.body.should == "Welcome, authenticated client."
  end

  it "is able to test requests requiring basic auth with long usernames or passwords" do
    with_basic_auth "xanthomata.loosish@shazbot.invalid", "super-super-super-super-super-super-dooper-secret"
    get "/protected"
    response.should have_status_code 200
  end

  it "is able to test the presence of specified response headers" do
    with_accept_header "application/json"
    get "/json_doc"
    response.should have_header(:content_type)
    response.should have_header("Content-Type")
    response.should_not have_header("This-Is-Not-A-Header-Name")
    
    response.should have_link_header
    response.should have_link_header({url: 'http://link.example.com', rel: 'search'})
    response.should have_link_header({'url' => 'http://link.example.com', 'rel' => 'search'})
    response.should have_link_header({url: 'http://link.example.com', 'rel' => 'search'})
  end

  it "has a helpful failure message for have_header" do
    with_accept_header "application/json"
    get "/json_doc"
    expect {response.should have_header(:not_a_real_header)}.to raise_error(/expected response headers .* to have header Not-A-Real-Header/)
    expect {response.should have_header(content_type: /xml/)}.to raise_error(%r{expected response headers .* to have header Content-Type with value /xml/})
    expect {response.should_not have_header(:content_type)}.to raise_error(/expected response headers .* to not have header Content-Type/)
    expect {response.should_not have_header('Content-Type' => /json/)}.to raise_error(%r{expected response headers .* to not have header Content-Type with value /json/})
  end

  it "is able to test the value of specified response headers" do
    with_accept_header "application/xml"
    get "/xml_doc"
    response.should have_header(content_type: %r{charset})
    response.should_not have_header(content_type: %r{json})
  end


  it "is able to test for content in the response body" do
    get "/"
    response.should have_content "Hello, world!"
    response.should have_content(/hello.*world/i)
  end

  it "has a helpful error message for have_content" do
    get "/"
    expect {response.should have_content "Foo!"}.to raise_error("expected Hello, world! to equal \"Foo!\"")
    expect {response.should have_content(/foo/)}.to raise_error("expected Hello, world! to match /foo/")
    expect {response.should_not have_content "Hello, world!"}.to raise_error("expected Hello, world! to not equal \"Hello, world!\"")
    expect {response.should_not have_content(/world/)}.to raise_error("expected Hello, world! to not match /world/")
  end

  it "is able to test for the presence of xml elements in the response body" do
    with_accept_header "application/xml"
    get "/xml_doc"
    response.should have_xpath "//foo/bar"
    response.should_not have_xpath "//bar/foo"
    response.should have_xpath "//foo", /Some/
    response.should_not have_xpath "//foo/bar", /foo/
  end

  it "is able to test for the presence of namespaced xml elements in the response body" do
    with_accept_header "application/xml"
    get "/xml_doc_with_namespaces"
    response.should have_xpath "//fake:foo/fake:bar", /more/

    # test a pathological case that was encountered in the real world
    with_accept_header "application/xml"
    get "/xml_doc_with_pathological_namespaces"
    response.should have_xpath "//fake:foo/fake:bar", /more/
  end

  it "is able to test for the presence of json elements in the response body" do
    with_accept_header "application/json"
    get "/json_doc"
    response.should have_jsonpath "root.foo.foo"
    response.should_not have_jsonpath "shazbot.mcgillicuddy"
    response.should have_jsonpath "root.foo.foo", /ow/
    response.should_not have_jsonpath "root.foo.foo", /oo/
  end

  it "gives a helpful error message when have_xpath fails" do
    with_accept_header "application/xml"
    get "/xml_doc"
    expect {response.should have_xpath "//not/a/valid/xpath"}.to raise_error(/^expected xpath .* in .*$/)
    expect {response.should have_xpath "//root/foo", /not there/}.to raise_error(%r{^expected xpath .* with value /not there/ in .*$})
    expect {response.should_not have_xpath "//foo/bar"}.to raise_error(/^expected xpath .* would not be in .*/)
    expect {response.should_not have_xpath "//root/foo", /Some/}.to raise_error(%r{^expected xpath .* with value /Some/ would not be in .*$})
  end
end

describe Skink::DSL, type: :api do
  context "using rack_test" do
    it_behaves_like "a REST API test language"
  end

  context "using Resourceful" do
    before { Skink.base_url = "http://localhost:4567" }
    it_behaves_like "a REST API test language"
  end
end

api_feature "Built-in acceptance test DSL" do
  background "with background" do
    @answer = 42
  end

  scenario "background exists" do
    @answer.should be 42
  end

  given(:user) { "yer mom" }

  scenario "given method works" do
    user.should eq "yer mom"
  end
end
