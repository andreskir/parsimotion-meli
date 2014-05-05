express = require 'express'
mongoose = require 'mongoose'
bodyParser = require 'body-parser'

app = express()

exports.app = app

app.set 'port', process.env.PORT or 4000
app.set 'storage-uri', process.env.MONGOHQ_URL or 'mongodb://localhost/widgets'
app.set 'parsimotion-api-uri', process.env.PARSIMOTION_API_URL
app.use bodyParser()

mongoose.connect app.get('storage-uri'), {}, (err) ->
  console.log "Mongoose - connection error: " + err if err?
  console.log "Mongoose - connection OK"

# -
# Routes
# -
app.get '/', (req, res) ->
  res.send 'Hello, Zaiste!'

require './model/user'
users = require './controller/users'
app.post    '/users',       users.create
app.get     '/users',       users.retrieve
app.get     '/users/:id',   users.retrieve
app.put     '/users/:id',   users.update
app.delete  '/users/:id',   users.delete

require './model/notification'
notifications = require './controller/notifications'
app.post    '/notifications',       notifications.push
app.get     '/notifications',       notifications.retrieve
app.get     '/notifications/:id',   notifications.retrieve

app.listen app.get('port'), () ->
  console.log "listening on port #{app.get('port')}"
