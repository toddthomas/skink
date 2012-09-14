require 'skink/client/base'
require 'skink/rack_test_client/rack_test_response'

require 'rack/test'

module Skink

class RackTestClient < Client::Base
  include Rack::Test::Methods

  attr_reader :app, :last_response

  def initialize(rack_app)
    @app = rack_app
  end

  def with_basic_auth(user_name, password, realm = nil)
    authorize(user_name, password)
  end

  def with_header(name, value)
    header(name, value)
  end

  def head(path)
    resp = super path
    @last_response = RackTestResponse.new resp
  end

  def get(path)
    resp = super path
    @last_response = RackTestResponse.new resp
  end

  def post(path, body = nil)
    resp = super(path, body)
    @last_response = RackTestResponse.new resp
  end

  def put(path, body)
    resp = super(path, body)
    @last_response = RackTestResponse.new resp
  end

  def delete(path)
    resp = super path
    @last_response = RackTestResponse.new resp
  end

  def response
    last_response
  end
end

end
