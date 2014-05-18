home = require 'home'

flow = require '../'

module.exports = flow.extension 'trigger',
  name: 'Trigger'
  info: """
    A trigger is just a definition of a name with parameters.
    The trigger construction function returns a fire callback.
  """
, (uid, options) ->
    home.endpoint uid, options, (args) ->
      flow.hub.emit uid, args

flow.trigger 'example',
  name: 'Example Trigger'
  info: """
    A trigger is an identifier that can be subscribed to.
    Everytime the trigger is fired all listening callbacks
    will be called.

    The trigger is emitted as an event from the `flow`
    object.

    The trigger can be fired by POSTing to the endpoint.
  """
  params:
    foo:
      type: 'integer'
      default: 42
