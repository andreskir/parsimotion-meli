restler = require 'restler'

exports.notify = (notification, accessToken) ->
    restler.postJson "http://staging--api-parsimotion-com-f7ilnpcypkb8.runscope.net/meli/importer#{notification.resource}", notification, accessToken: accessToken
