flow = require '../'

flow.sink 'flow', ->
  params:
    action:
      type: 'string'
      required: 'yes'
, (init_args) ->
  [app_uid, action_uid] = init_args.action.split '.'
  action = home.apps[app_uid]?.actions?[action_uid]
