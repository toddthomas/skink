require 'sinatra'

helpers do
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', 'admin']
  end
end

get '/' do
  "Hello, world!"
end

post '/' do
  request.body
end

put '/' do
  request.body
end

delete '/' do
  "Deleted"
end

get '/foo', :provides => :json do
  "{\"foo\": 42}"
end

get '/protected' do
  protected!
  "Welcome, authenticated client."
end
