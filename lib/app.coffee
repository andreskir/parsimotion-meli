express = require 'express'
mongoose = require 'mongoose'
bodyParser = require 'body-parser'
config = require "./config"
basicAuth = require 'basic-auth-connect'

app = express()

exports.app = app

app.set 'port', config.port
app.use bodyParser()

mongoose.connect config.mongodb.uri, {}, (err) ->
  console.log "Mongoose - connection error: " + err if err?
  console.log "Mongoose - connection OK"

# -
# Routes
# -
authMiddleware = basicAuth config.auth.user, config.auth.password

console.log config.auth.user
console.log config.auth.password

app.get '/', (req, res) ->
  res.send 'Hello, Zaiste!'

require './model/user'
users = require './controller/users'
app.post    '/users', authMiddleware, users.create
app.get     '/users', authMiddleware, users.retrieve
app.get     '/users/:id', authMiddleware, users.retrieve

require './model/notification'
notifications = require './controller/notifications'
app.post    '/notifications', notifications.push
app.get     '/notifications', authMiddleware, notifications.retrieve
app.get     '/notifications/:id', authMiddleware, notifications.retrieve

app.listen app.get('port'), () ->
  console.log "listening on port #{app.get('port')}"
