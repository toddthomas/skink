require 'skink/client/response'

module Skink

class ResourcefulResponse < Client::Response
  attr_reader :native_response

  def initialize(native_response)
    @native_response = native_response
  end

  def status_code
    native_response.code
  end

  def has_status_code? code
    native_response.code == code
  end

  def headers
    native_response.headers.to_hash
  end

  def body
    native_response.body || ""
  end
end

end
