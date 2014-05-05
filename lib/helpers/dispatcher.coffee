restler = require 'restler'
config = require "../config"

exports.notify = (notification, accessToken) ->
    restler.postJson "#{config.parsimotionApi.uri}/meli/importer#{notification.resource}", notification, accessToken: accessToken
