require_relative './spec_helper'

shared_examples "a REST API test language" do
  it "is able to test a HEAD" do
    head "/"
    response.status_code.should == 200
    response.body.size.should == 0
  end

  it "is able to test a GET" do
    get "/"
    response.status_code.should == 200
    response.body.should == "Hello, world!"
  end

  it "is able to test a POST" do
    body = "<ping/>"
    with_content_type_header "application/xml"
    post "/", body
    response.status_code.should == 200
    response.body.should == body
  end

  it "is able to test a PUT" do
    body = "{\"ping\": \"hello\"}"
    with_content_type_header "application/json"
    put "/", body
    response.status_code.should == 200
    response.body.should == body
  end

  it "is able to test a DELETE" do
    delete "/"
    response.status_code.should == 200
    response.body.should == "Deleted"
  end

  it "is able to test a request with additional headers" do
    with_accept_header "application/json"
    get "/foo"
    response.status_code.should == 200
    response.body.should == "{\"foo\": 42}"
  end

  it "is able to test requests which require basic authentication" do
    with_basic_auth "admin", "admin"
    get "/protected"
    response.status_code.should == 200
    response.body.should == "Welcome, authenticated client."
  end

  it "is able to test requests which require basic authentication for specified realm" do
    get "/protected"
    response.status_code.should == 401

    with_basic_auth "admin", "admin", "Restricted Area"
    get "/protected"
    response.status_code.should == 200
    response.body.should == "Welcome, authenticated client."
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
