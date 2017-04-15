require 'rubygems'
require 'bundler'
Bundler.require
require 'sinatra'
require 'rack/contrib'
require 'sinatra-websocket'
require 'json'
require "sinatra/activerecord"
require "sinatra/json"
use Rack::PostBodyContentTypeParser

Dir["./models/*.rb"].each {|file| require file }
Dir["./services/*.rb"].each {|file| require file }

set :database, {adapter: "sqlite3", database: "foo.sqlite3"}
set :show_exceptions, false
set :server, 'thin'
set :sockets, []
set :signing_key, NtpJwt.keys[:signing_key]
set :verify_key, NtpJwt.keys[:verify_key]
enable :sessions
set :session_secret, 'super secret' 
set :root, File.join(File.dirname(__FILE__), '..')
# sets the view directory correctly
set :views, Proc.new { File.join(root, "views") } 

helpers do 
  def params
    JsonHelper.parse_json(request)
  end

  def protected!
    return if AuthHelper.authorized?(request, settings)
    redirect to('/login')
  end
end

get '/' do 
  json hello: 'world'
end

post '/users' do 
  user = CreateUser.new(params).call
  json user
end

post '/login' do
  json params
end

get '/gps/mobile' do
  if !request.websocket?

    erb :index
  else
    request.websocket do |ws|
      ws.onopen do
        ws.send("Hello World!")
        settings.sockets << ws
      end
      ws.onmessage do |msg|
        EM.next_tick { settings.sockets.each{|s| s.send(msg) } }
      end
      ws.onclose do
        warn("websocket closed")
        settings.sockets.delete(ws)
      end
    end
  end
end

error 400..510 do

end

