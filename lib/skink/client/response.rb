require 'skink/client/utils'

require 'nokogiri'
require 'jsonpath'
require 'link_header'
require 'hash_deep_merge'

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
    elems = [elems] unless elems.respond_to? :any?
    
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

  def link_header
    raise NotImplementedError
  end

  def links
    if link_header
      LinkHeader.parse(link_header).to_a.map do |linkarr|
        {url: linkarr[0]}.merge Hash[linkarr[1]]
      end
    end
  end
  
  # example match keys for the link header:
  # :url => "http://example.com",
  # :rel => "search"
  def has_link_header?(opts=nil)
    if opts.nil?
      links.any?
    else
      links.any? do |link|
        link == link.deep_merge(opts)
      end
    end
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
