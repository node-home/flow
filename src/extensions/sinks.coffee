flow = require '../'

module.exports = flow.extension 'sink',
  name: "Sink"
  info: """
    A sink is an object that has a do function, which
    can be hooked up to a feed to handle an incoming
    stream of data.
  """
  , ->
    console.log "flow.extensions.sinks Not Implemented"

flow.sink 'example',
  name: "Example Sink"
  info: """
    The callback is the initializer closure.
    It should return a function that hooks up to a feed.
  """
  , (init_args) ->
    (feed_args) ->
      console.log 'init_args', init_args
      console.log 'feed_args', feed_args
