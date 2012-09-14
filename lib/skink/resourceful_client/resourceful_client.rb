require 'skink/client/base'
require 'skink/resourceful_client/resourceful_response'

require 'resourceful'
require 'httpauth'

module Skink

class ResourcefulClient < Client::Base
  attr_reader :base_url, :headers, :http_accessor, :last_response

  def initialize(base_url)
    @base_url = base_url
    @headers = {}
  end

  def http_accessor
    @http_accessor ||= Resourceful::HttpAccessor.new
  end

  def with_basic_auth(user_name, password)
    #http_accessor.add_authenticator Resourceful::PromiscuousBasicAuthenticator.new(user_name, password)
    http_accessor.add_authenticator Resourceful::BasicAuthenticator.new("Restricted Area", user_name, password)
  end

  def with_header(name, value)
    headers.merge! name => value
  end

  def head(path)
    begin
      resp = http_accessor.resource(base_url + path).head(headers)
    rescue Resourceful::UnsuccessfulHttpRequestError => e
      resp = e.http_response
    end

    @last_response = ResourcefulResponse.new resp
  end

  def get(path)
    begin
      resp = http_accessor.resource(base_url + path).get(headers)
    rescue Resourceful::UnsuccessfulHttpRequestError => e
      resp = e.http_response
    end

    @last_response = ResourcefulResponse.new resp
  end

  def post(path, body = nil)
    begin
      resp = http_accessor.resource(base_url + path).post(body, headers)
    rescue Resourceful::UnsuccessfulHttpRequestError => e
      resp = e.http_response
    end

    @last_response = ResourcefulResponse.new resp
  end

  def put(path, body)
    begin
      resp = http_accessor.resource(base_url + path).put(body, headers)
    rescue Resourceful::UnsuccessfulHttpRequestError => e
      resp = e.http_response
    end

    @last_response = ResourcefulResponse.new resp
  end

  def delete(path)
    begin
      resp = http_accessor.resource(base_url + path).delete(headers)
    rescue Resourceful::UnsuccessfulHttpRequestError => e
      resp = e.http_response
    end

    @last_response = ResourcefulResponse.new resp
  end

  def response
    last_response
  end
end

end
