flow = require '../'

flow.feed 'flow', ->
  name: "Flow"
  info: """
    This is the feed that serves all the triggers in
    home and calls actions for them.

    The callback function lets you register a Flow object.
  """
  public: no
  params:
    trigger:
      type: 'string'
      required: yes
    action:
      type: 'function'
      required: yes
, (args) ->
  flow.hub.on args.trigger, args.action
