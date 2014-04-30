mongoose = require 'mongoose'
Schema = mongoose.Schema

Notification = new mongoose.Schema
  notification: Schema.Types.Mixed
  response: Schema.Types.Mixed

mongoose.model "Notification", Notification