require 'skink/dsl'

Skink.rack_app = Rack::Builder.new do
  map "/" do
    if Rails.version.to_f >= 3.0
      run Rails.application
    else # Rails 2
      use Rails::Rack::Static
      run ActionController::Dispatcher.new
    end
  end
end.to_app
