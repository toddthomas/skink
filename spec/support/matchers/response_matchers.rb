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
