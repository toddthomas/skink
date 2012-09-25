require_relative './spec_helper'

shared_examples "a REST API test language" do
  it "is able to test a HEAD" do
    head "/"
    response.should have_status_code 200
    response.body.size.should == 0
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

  it "is able to test the presence of specified response headers" do
    with_accept_header "application/json"
    get "/json_doc"
    response.should have_header(:content_type)
    response.should have_header("Content-Type")
    response.should_not have_header("This-Is-Not-A-Header-Name")
  end

  it "is able to test the value of specified response headers" do
    with_accept_header "application/xml"
    get "/xml_doc"
    response.should have_header(content_type: %r{charset})
    response.should_not have_header(content_type: %r{json})
  end

  it "is able to test for the presence of elements in the response body" do
    with_accept_header "application/xml"
    get "/xml_doc"
    response.should have_xpath "//foo/foo"
    response.should_not have_xpath "//bar/foo"
    response.should have_xpath "//foo", /Some/
    response.should_not have_xpath "//foo", /bar/

    with_accept_header "application/json"
    get "/json_doc"
    response.should have_jsonpath "root.foo.foo"
    response.should_not have_jsonpath "shazbot.mcgillicuddy"
    response.should have_jsonpath "root.foo.foo", /ow/
    response.should_not have_jsonpath "root.foo.foo", /oo/
  end
end

describe Skink::DSL do
  context "using rack_test" do
    it_behaves_like "a REST API test language"
  end

  context "using Resourceful" do
    before { Skink.base_url = "http://localhost:4567" }
    it_behaves_like "a REST API test language"
  end
end
