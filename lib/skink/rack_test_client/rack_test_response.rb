require 'skink/client/response'

module Skink

class RackTestResponse < Client::Response
  attr_reader :native_response

  def initialize(native_response)
    @native_response = native_response
  end

  def status_code
    native_response.status
  end

  def has_status_code? code
    native_response.status == code
  end

  def headers
    if native_response.is_a? Rack::Response
      native_response.header
    else
      native_response.headers
    end
  end

  def link_header
    headers["Link"]
  end

  def body
    native_response.body
  end
end

end
