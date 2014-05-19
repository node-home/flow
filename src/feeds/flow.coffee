flow = require '../'

###
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
###
module.exports = flow.feed 'flow', ->
  name: "Flow"
  info: """
    Expose the flow hub as a feed.
  """
, (emit) ->
  console.log "LISTENING *"
  flow.hub.on 'echo', (args...) ->
    console.log "FLOW ECHO TRIGGERED", args...
    emit @event, args...
  flow.hub.on '*', (args...) ->
    console.log "FLOW * TRIGGERED", args...
    emit @event, args...
