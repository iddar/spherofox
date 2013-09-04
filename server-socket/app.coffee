
# Module dependencies
express = require 'express'
routes = require './routes'
http = require 'http'
path = require 'path'
socket = require 'socket.io'
assets = require 'connect-assets'

app = express()
#Create an instance of the object to be reused, for example: io = socket.listen(server)
server = http.createServer(app)
io = socket.listen server

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router

  #uncomment to enable the static files server
  app.use express.static( path.join( __dirname, 'public' ) )

app.configure 'development', ->
  app.use express.errorHandler()
  app.use assets
    build: true
    compress: true
    buildDir: false

app.configure 'production', ->
  app.use assets
    build: true
    compress: true

app.get '/', routes.index

#app.get '/manifest.webapp', (rep, res) ->
 # res.contentType('application/json');


io.sockets.on 'connection', (socket) ->
  socket.broadcast.emit 'sphero:color', null
#  console.log("Connected!");
#  console.log("  c - change color");
#  console.log("  b/n - backled on/off");
#  console.log("  up - move forward");
#  console.log("  back - stop");
#  console.log("  left - change heading 45 deg left");
#  console.log("  right - change heading 45 deg right");
  
  socket.on 'web:color', (data) ->
    socket.broadcast.emit 'sphero:color', data
    return 

  socket.on 'web:backled', (data) ->
    socket.broadcast.emit 'sphero:backled', data
    return  

  socket.on 'web:forward', (data) ->
    console.log "abanza"
    socket.broadcast.emit 'sphero:forward', data
    return  

  socket.on 'web:stop', (data) ->
    console.log "Parra"
    socket.broadcast.emit 'sphero:stop', data
    return  

  socket.on 'web:left', (data) ->
    socket.broadcast.emit 'sphero:left', data
    return 

  socket.on 'web:right', (data) ->
    socket.broadcast.emit 'sphero:right', data
    return  

  return

server.listen app.get('port'), ->
  console.log "Express server listening on port #{app.get 'port'}"
