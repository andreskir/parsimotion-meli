mongoose = require 'mongoose'

toDto = (user) ->
  id: user._id
  accessToken: user.accessToken

toModel = (dto) ->
  _id: dto.id
  accessToken: dto.accessToken

exports.retrieve = (req, res) ->
  Resource = mongoose.model('User')

  if req.params.id?
    Resource.findById req.params.id, (err, resource) ->
      res.send(500, { error: err }) if err?
      res.send(toDto resource) if resource?
      res.send(404)
  else
    Resource.find {}, (err, coll) ->
      res.send(coll.map (it) -> toDto it)

exports.create = (req, res) ->
  Resource = mongoose.model('User')
  fields = toModel req.body

  r = new Resource(fields)
  r.save (err, resource) ->
    return res.send(500, { error: err }) if err?
    res.send(toDto resource)

exports.update = (req, res) ->
  Resource = mongoose.model('User')
  fields = req.body

  Resource.findByIdAndUpdate req.params.id, { $set: fields }, (err, resource) ->
    return res.send(500, { error: err }) if err?
    
    if resource?
      res.send(resource)
    else
      res.send(404)

exports.delete = (req, res) ->
  Resource = mongoose.model('User')

  Resource.findByIdAndRemove req.params.id, (err, resource) ->
    return res.send(500, { error: err }) if err?
    if resource?
      res.send(200)
    else
      res.send(404)