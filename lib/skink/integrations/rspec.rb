Dir[File.dirname(__FILE__) + "/../../../spec/support/**/*.rb"].each {|f| STDOUT.puts f; require f}

require 'skink/dsl'

RSpec.configure do |config|
  config.include Skink::DSL

  config.after do
    if self.class.include?(Skink::DSL)
      Skink.reset_client!
    end
  end
end
