{signaturify} = require 'home/src/core'

flow = require '../'
core = require '../core'

# TODO setup socket connectors
url       = require 'url'
http      = require 'http'
io        = require 'socket.io'

events    =
  EventEmitter: require('eventemitter2').EventEmitter2

module.exports = flow.extension 'feed',
  name: "Feed"
  info: """
    A feed is a stream of information, available through
    websocket or callback or endpoint.

    home.feeds.time

    This factory returns objects with 3 subscription functions.
    It also sets up a websocket that can be connected to.

    Each of subscription function returns its unsubscriber.

    Feed should cache the last value and send it upon connect.
  """
  , (uid, options, setup) ->
    # TODO use a shared emitter with channel? This doesn't close properly
    # emitter relays the events from the feed
    emitter = new events.EventEmitter
    setup (args...) -> emitter.emit uid, args...

    # Serve a websocket that can be connected to by clients
    serverSocket = io.listen()
      .of "/#{uid}"
      .on 'connection', (socket) ->
        emitter.on uid, (args) ->
          serverSocket.emit uid, args

    # Various methods to subscribe to the feed with
    subscribers = core.buildSubscribers uid, emitter
    # Expose the subscribers via endpoints
    endpoints = core.buildEndpoint uid, subscribers

    # Return a function that exposes the various ways of
    # connecting to the feed
    signaturify
      socket:
        type: String
      endpoint:
        type: String
      callback:
        type: 'function'
    , (options={}) ->
      options = callback: options if typeof options is 'function'
      removers = sub options[key] for key, sub of subscribers when options[key]?
      -> remover() for remover in removers


# flow.feed 'example', ->
#   info: """
#   """
# , (emit) ->
#   flow.hub.on '*', (args...) ->
#     emit @event, args...
