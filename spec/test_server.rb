# encoding: UTF-8

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
    @auth.provided? && @auth.basic? && @auth.credentials && (@auth.credentials == ['admin', 'admin'] || @auth.credentials == ['xanthomata.loosish@shazbot.invalid', 'super-super-super-super-super-super-dooper-secret'])
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

get '/xml_doc', :provides => :xml do
  <<-END
  <?xml version="1.0" encoding="UTF-8"?>
  <root>
    <foo attr=\"true\">Some text<bar>more text</bar></foo>
  </root>
  END
end

get '/xml_doc_with_namespaces', :provides => :xml do
  <<-END
  <?xml version="1.0" encoding="UTF-8"?>
  <root xmlns:fake="http://www.example.org/xmlns/fake">
    <fake:foo attr=\"true\">Some text<fake:bar>more text</fake:bar></fake:foo>
  </root>
  END
end

get '/xml_doc_with_pathological_namespaces', :provides => :xml do
  <<-END
  <?xml version="1.0" encoding="UTF-8"?>
  <root xmlns="http://www.example.org/xmlns/fake" xmlns:fake="http://www.example.org/xmlns/fake">
    <foo attr=\"true\">Some text<bar>more text</bar></foo>
  </root>
  END
end

get '/json_doc', :provides => :json do
  response.headers["Link"] = "<http://link.example.com>; rel=\"search\""
  '{"root": {"foo": {"foo": "howdy"}}}'
end
