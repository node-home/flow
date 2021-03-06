flow = require '../'

module.exports = flow.extension 'sink',
  name: "Sink"
  info: """
    A sink is an object that has a do function, which
    can be hooked up to a feed to handle an incoming
    stream of data.
  """
, (uid, options, setup) ->
    console.log "flow.extensions.sinks Not Implemented"
    setup




flow.sink 'example',
  name: "Example Sink"
  info: """
    The callback is the initializer closure.
    It should return a function that hooks up to a feed.
  """
  , (init_args) ->
    console.log 'init_args', init_args
    (feed_args) ->
      console.log 'feed_args', feed_args
