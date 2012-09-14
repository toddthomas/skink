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

  def headers
    native_response.header
  end

  def body
    native_response.body
  end
end

end
