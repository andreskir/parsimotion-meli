express = require 'express'
mongoose = require 'mongoose'

app = express()

app.configure ->
  app.set 'port', process.env.PORT or 4000
  app.set 'storage-uri', process.env.MONGOHQ_URL or 'mongodb://localhost/widgets'
  app.use express.bodyParser()
  app.use express.methodOverride()

mongoose.connect app.get('storage-uri'), {}, (err) ->
  console.log "Mongoose - connection error: " + err if err?
  console.log "Mongoose - connection OK"

require './model/user'

# -
# Routes
# -
app.get '/', (req, res) ->
  res.send 'Hello, Zaiste!'

users = require './controller/users'
app.post    '/users',       users.create
app.get     '/users',       users.retrieve
app.get     '/users/:id',   users.retrieve
app.put     '/users/:id',   users.update
app.delete  '/users/:id',   users.delete

app.listen app.get('port'), () ->
  console.log "listening on port #{app.get('port')}"
