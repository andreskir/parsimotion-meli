mongoose = require 'mongoose'
User = mongoose.model('User')

toDto = (user) ->
  id: user._id
  accessToken: user.accessToken

toModel = (dto) ->
  _id: dto.id
  accessToken: dto.accessToken

exports.retrieve = (req, res) ->
  if req.params.id?
    User.findById req.params.id, (err, resource) ->
      res.send(500, { error: err }) if err?
      res.send(toDto resource) if resource?
      res.send(404)
  else
    User.find {}, (err, coll) ->
      res.send(coll.map (it) -> toDto it)

exports.create = (req, res) ->
  user = toModel req.body
  
  document = new User(user).toObject()
  delete document._id

  User.findByIdAndUpdate user._id, document, {upsert: true}, (err, resource) ->
    return res.send(500, { error: err }) if err?
    res.send(toDto resource)
