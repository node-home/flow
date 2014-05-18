home = require 'home'

ioClient = require 'socket.io-client'

###
Subscription factory factory.

Offers three factories to subscribe to a feed:
- by websocket
- by callback url
- by callback function
The factories each return an unsubscribe function
###
exports.buildSubscribers = (uid, emitter) ->
  # Connect to a websocket and push the data to it.
  websocket: (clientUrl) ->
    clientSocket = ioClient.connect clientUrl
    emitter.on uid, func = (args) ->
      clientSocket.emit uid, args
    -> emitter.removeListener uid, func

  # Connect an url that is called on each tick.
  url: (clientUrl) ->
    {host, path, port} = url.parse clientUrl

    options =
      hostname: host
      port: port
      path: path
      method: 'POST'

    emitter.on uid, func = (args) ->
      req = http.request options
      req.write JSON.stringify args
      req.end()

    -> emitter.removeListener uid, func

  # Connect a callback function that is called on each tick
  callback: (callback) ->
    emitter.on uid, func = (args) ->
      # TODO use async?
      setTimeout (-> callback args), 0
    -> emitter.removeListener uid, func

###
Endpoint factory method.

Builds an endpoint to subscribe to feeds.
This can be done through a websocket url and/or
callback url.
###
exports.buildEndpoints = (uid, feed) ->
  home.endpoint uid,
    method: 'POST'
    params:
      socket:
        type: String
      endpoint:
        type: String
  , ({socket, endpoint}) ->
    removers = []
    removers.push feed.websocket socket if socket?
    removers.push feed.endpoint endpoint if endpoint?

    # TODO return a DELETE endpoint to unsubscribe
    #
    # OR
    #
    # Create a resource that can be options
    home.endpoint uid,
      method: 'DELETE'
      url: "/TODO/feed/uuid"
    , (args) ->
      remover() for remover in removers

      #@emit 'endpoint:destroy', 'DELETE', url

