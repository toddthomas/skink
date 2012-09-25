require 'skink'
require 'skink/client/utils'

module Skink
module Client

class Base
  include Utils

  def with_header(name, value)
    raise NotImplementedError
  end

  def with_basic_auth(user_name, email_address, realm = nil)
    raise NotImplementedError
  end

  def head(path)
    raise NotImplementedError
  end

  def get(path)
    raise NotImplementedError
  end

  def post(path, body = nil)
    raise NotImplementedError
  end

  def put(path, body)
    raise NotImplementedError
  end

  def delete(path)
    raise NotImplementedError
  end

  def trace(path)
    raise NotImplementedError
  end

  def options(path)
    raise NotImplementedError
  end

  def connect(path)
    raise NotImplementedError
  end

  def patch(path, body = nil)
    raise NotImplementedError
  end

  def response
    raise NotImplementedError
  end

  def method_missing(name, *args)
    if name.match(/with_(\w+)_header/)
      with_header(normalize_header_name($1), *args)
    else
      super(name, *args)
    end
  end
end

end
end
