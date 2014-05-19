flow      = require '../flow'

Condition = require '../Condition'

module.exports = home.model 'Flow',
  info: """
    A flow is a special sink that subscribes to the
    flow feed and calls a specific action on trigger
    under satisfied conditions.
  """
  schema:
    action_id:
      type: String
      required: yes
    trigger:
      type: String
      required: yes
    name:
      type: String
      required: yes
    conditions:
      model: ['Condition']

  virtuals:
    action: ->
      [app_uid, action_uid] = @action_id.split '.'
      home.apps[app_uid]?.actions?[action_uid]

  callback: (args) =>
    # TODO defaultify the args before doing the conditions
    for condition in @conditions
      unless condition.test args
        return "TODO condition failed"

      @action args

  listen: ->
    home.feeds.flow @trigger, @callback
