mongoose = require 'mongoose'
restler = require 'restler'

exports.retrieve = (req, res) ->
  Resource = mongoose.model('Notification')

  if req.params.id?
    Resource.findById req.params.id, (err, resource) ->
      res.send(500, { error: err }) if err?
      res.send(resource) if resource?
      res.send 404
  else
    Resource.find {}, (err, coll) ->
      res.send coll

exports.push = (req, res) ->
  Resource = mongoose.model('Notification')
  notification = req.body

  restler.postJson("http://staging--api-parsimotion-com-f7ilnpcypkb8.runscope.net/meli/pushnotifications", notification).on "complete", (data) ->
    r = new Resource notification: notification, response: data
    r.save (err, resource) ->
      if err?
        res.send error: err
      else
        res.send resource
