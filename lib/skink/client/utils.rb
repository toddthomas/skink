module Skink
module Client

module Utils
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
