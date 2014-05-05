restler = require 'restler'
app = require("../app").app

exports.notify = (notification, accessToken) ->
    restler.postJson "#{app.get 'parsimotion-api-uri'}/meli/importer#{notification.resource}", notification, accessToken: accessToken
