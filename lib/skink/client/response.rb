require 'skink/client/utils'

require 'nokogiri'
require 'jsonpath'

module Skink
module Client

class Response
  include Utils

  def status_code
    raise NotImplementedError
  end

  def headers
    raise NotImplementedError
  end

  def find_header header
    case header
    when String
      headers[headers.keys.detect {|key| key.match(/^#{header}$/i)}] rescue nil
    when Symbol
      headers[headers.keys.detect {|key| key.match(/^#{header.to_s.gsub('_', '-')}$/i)}] rescue nil
    end
  end

  def has_header? header
    if find_header(header)
      true
    elsif header.respond_to? :keys
      header.all? do |key, value|
         value === find_header(key)
      end
    else
      false
    end
  end

  def body
    raise NotImplementedError
  end

  def xml_doc
    @xml_doc ||= Nokogiri::XML.parse body
  end

  def xpath path
    xml_doc.xpath path
  end

  def has_xpath? path, value = nil
    elems = xpath(path)
    if value
      block = ->(elem) {value === elem.to_s}
    else
      block = nil
    end

    elems.any?(&block)
  end

  def json_doc
    @json_doc ||= MultiJson.load body
  end

  def jsonpath path
    JsonPath.new(path).on json_doc
  end

  def has_jsonpath? path, value = nil
    elems = jsonpath(path)
    if value
      block = ->(elem) {value === elem}
    else
      block = nil
    end

    elems.any?(&block)
  end

  def method_missing(name, *args)
    if name.match(/has_(\w+)_header\?/)
      headers[normalize_header_name($1)] === args.first
    else
      super
    end
  end
end

end
end
