require 'rspec/expectations'
require 'skink/client/utils'
include Skink::Client::Utils

RSpec::Matchers.define :have_status_code do |expected|
  match do |response|
    response.has_status_code? expected
  end

  failure_message_for_should do |response|
    "expected status code #{expected}, but got #{response.status_code}"
  end

  failure_message_for_should_not do |response|
    "expected status code would not be #{expected}, but dang, it was"
  end
end

RSpec::Matchers.define :have_header do |expected|
  match do |response|
    response.has_header? expected
  end

  failure_message_for_should do |response|
    if expected.respond_to? :keys
      "expected response headers #{response.headers.inspect} to have header #{normalize_header_name(expected.keys.first)} with value #{expected.values.first.inspect}"
    else
      "expected response headers #{response.headers.inspect} to have header #{normalize_header_name(expected)}"
    end
  end

  failure_message_for_should_not do |response|
    if expected.respond_to? :keys
      "expected response headers #{response.headers.inspect} to not have header #{normalize_header_name(expected.keys.first)} with value #{expected.values.first.inspect}"
    else
      "expected response headers #{response.headers.inspect} to not have header #{normalize_header_name(expected)}"
    end
  end
end

RSpec::Matchers.define :have_link_header do |expected|
  match do |response|
    response.has_link_header? expected
  end

  failure_message_for_should do |response|
    if expected.respond_to? :keys
      "expected response headers #{response.headers.inspect} to have link header header #{normalize_header_name(expected.keys.first)} matching #{expected.values.first.inspect}"
    else
      "expected response headers #{response.headers.inspect} to have header #{normalize_header_name(expected)}"
    end
  end

  failure_message_for_should_not do |response|
    if expected.respond_to? :keys
      "expected response headers #{response.headers.inspect} to not have link header #{normalize_header_name(expected.keys.first)} matching #{expected.values.first.inspect}"
    else
      "expected response headers #{response.headers.inspect} to not have link header #{normalize_header_name(expected)}"
    end
  end
end



RSpec::Matchers.define :have_content do |expected|
  match do |response|
    expected === response.body
  end

  failure_message_for_should do |response|
    "expected #{response.body} to #{expected.is_a?(Regexp) ? "match" : "equal"} #{expected.inspect}"
  end

  failure_message_for_should_not do |response|
    "expected #{response.body} to not #{expected.is_a?(Regexp) ? "match" : "equal"} #{expected.inspect}"
  end
end

RSpec::Matchers.define :have_xpath do |xpath, value|
  match do |response|
    response.has_xpath? xpath, value
  end

  failure_message_for_should do |response|
    "expected xpath #{xpath}#{value ? " with value #{value.inspect}" : ""} in #{response.body}"
  end

  failure_message_for_should_not do |response|
    "expected xpath #{xpath}#{value ? " with value #{value.inspect}" : ""} would not be in #{response.body}"
  end
end
