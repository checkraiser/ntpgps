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
register Config
enable :sessions

Dir["./helpers/*.rb"].each {|file| require file }
Dir["./concerns/*.rb"].each {|file| require file }
Dir["./models/*.rb"].each {|file| require file }
Dir["./services/*.rb"].each {|file| require file }

set :root, File.join(File.dirname(__FILE__), '..')
set :server, 'thin'
set :sockets, []
set :database, {adapter: "sqlite3", database: "foo_#{ENV['RACK_ENV']}.sqlite3"}
set :show_exceptions, false
set :session_secret, 'super secret' 
set :views, Proc.new { File.join(root, "views") } 

helpers do 
  def params
    JsonHelper.parse_json(request)
  end

  def protected!
    return if AuthHelper.authorized?(request, settings, session)
    redirect to('/login')
  end
end

post '/test' do 
  p params
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

