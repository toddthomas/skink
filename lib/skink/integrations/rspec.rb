Dir[File.dirname(__FILE__) + "/../../../spec/support/**/*.rb"].each {|f| require f}

require 'skink/dsl'

# Pretty much everything that follows gratefully borrowed from Capybara.

module Skink
  module Features
    def self.included(base)
      base.instance_eval do
        alias :background :before
        alias :scenario :it
      end
    end
  end
end

def self.api_feature(*args, &block)
  options = if args.last.is_a?(Hash) then args.pop else {} end
  options[:skink_features] = true
  options[:type] = :api
  options[:caller] ||= caller
  args.push(options)

  describe(*args, &block)
end

RSpec.configure do |config|
  config.include Skink::DSL, type: :api
  config.include Skink::Features, skink_features: true

  config.after do
    if self.class.include?(Skink::DSL)
      Skink.reset_client!
    end
  end
end
