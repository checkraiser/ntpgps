require 'rubygems'
require 'bundler'
Bundler.require
require 'sinatra'
require 'sinatra-websocket'
require 'json'
require "sinatra/activerecord"

Dir["./models/*.rb"].each {|file| require file }
Dir["./services/*.rb"].each {|file| require file }

set :database, {adapter: "sqlite3", database: "foo.sqlite3"}
set :show_exceptions, false
set :server, 'thin'
set :sockets, []
set :signing_key, NtpJwt.keys[:signing_key]
set :verify_key, NtpJwt.keys[:verify_key]

helpers do 
  def params
    JsonHelper.parse_json(request)
  end
end


post '/users' do 
  puts params["email"]
  puts params["password"]

end

post '/login' do
  puts params["email"]
  puts params["password"]
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

__END__
@@ index
<html>
  <body>
     <h1>Simple Echo & Chat Server</h1>
     <form id="form">
       <input type="text" id="input" value="send a message"></input>
     </form>
     <div id="msgs"></div>
  </body>

  <script type="text/javascript">
    window.onload = function(){
      (function(){
        var show = function(el){
          return function(msg){ el.innerHTML = msg + '<br />' + el.innerHTML; }
        }(document.getElementById('msgs'));

        var ws       = new WebSocket('ws://' + window.location.host + window.location.pathname);
        ws.onopen    = function()  { show('websocket opened'); };
        ws.onclose   = function()  { show('websocket closed'); }
        ws.onmessage = function(m) { show('websocket message: ' +  m.data); };

        var sender = function(f){
          var input     = document.getElementById('input');
          input.onclick = function(){ input.value = "" };
          f.onsubmit    = function(){
            ws.send(input.value);
            input.value = "send a message";
            return false;
          }
        }(document.getElementById('form'));
      })();
    }
  </script>
</html>
