ioClient = require 'socket.io-client'

###
Subscription factory method.
###
exports.buildSubscribers = (uid, emitter) ->
    # Connect to a websocket and push the data to it.
  websocket: (clientUrl) ->
    clientSocket = ioClient.connect clientUrl
    emitter.on uid, func = (args) ->
      clientSocket.emit uid, args
    -> emitter.removeListener uid, func

  # Connect an endpoint that is called on each tick.
  endpoint: (clientUrl) ->
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
###
exports.buildEndpoint = (uid, feed) ->
  endpoint uid,
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
    endpoint uid,
      method: 'DELETE'
      url: "/TODO/feed/uuid"
    , (args) ->
      remover() for remover in removers

      #@emit 'endpoint:destroy', 'DELETE', url
