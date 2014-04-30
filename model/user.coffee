mongoose = require 'mongoose'

User = new mongoose.Schema
  _id: Number
  accessToken: String

mongoose.model "User", User