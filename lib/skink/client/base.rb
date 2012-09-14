require 'skink'

module Skink
module Client

class Base
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
      super
    end
  end

private
  def normalize_header_name(name)
    # c.f http://en.wikipedia.org/wiki/List_of_HTTP_header_fields

    case name
    # special cases
    when /^content_md5$/i
      return "Content-MD5"
    when /^te$/i
      return "TE"
    when /^dnt$/i
      return "DNT"
    when /^etag$/i
      return "ETag"
    when /^www_authenticate$/i
      return "WWW-Authenticate"
    end

    # otherwise this should work
    name.split("_").map(&:capitalize).join("-")
  end
end

end
end
