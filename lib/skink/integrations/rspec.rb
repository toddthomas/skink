require 'skink/dsl'

RSpec.configure do |config|
  config.include Skink::DSL

  config.after do
    if self.class.include?(Skink::DSL)
      Skink.reset_client!
    end
  end
end
