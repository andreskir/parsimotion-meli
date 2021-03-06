mongoose = require 'mongoose'
restler = require 'restler'
dispatcher = require "../helpers/dispatcher"

exports.retrieve = (req, res) ->
  Notification = mongoose.model('Notification')

  if req.params.id?
    Notification.findById req.params.id, (err, resource) ->
      res.send(500, { error: err }) if err?
      res.send(resource) if resource?
      res.send 404
  else
    Notification.find {}, (err, coll) ->
      res.send coll

exports.push = (req, res) ->
  Notification = mongoose.model('Notification')
  notification = req.body

  meliUserId = notification.user_id

  mongoose.model('User').findById meliUserId, (err, user) ->
    return res.send(error: "Parsimotion token not found for user #{meliUserId}") if !user?

    dispatcher.notify(notification, user.accessToken).on "complete", (data) ->
      r = new Notification notification: notification, response: data
      r.save (err, resource) ->
        if err?
          res.send error: err
        else
          res.send resource
