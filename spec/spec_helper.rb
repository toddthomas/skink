__DIR__ = File.dirname(__FILE__)

$LOAD_PATH << File.join(__DIR__, "..", "lib")

require 'skink/integrations/rspec'

require 'test_server'
Skink.rack_app = Rack::Builder.new do
  map "/" do
    run Sinatra::Application
  end
end.to_app

# Start "remote" test server in another thread.
@server = Thread.new do
  Sinatra::Application.run!
end

# Kill the server process when rspec finishes.
at_exit { @server.exit }

# Let the server start up.
sleep 1
