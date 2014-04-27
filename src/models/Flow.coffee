flow      = require '../flow'

Condition = require '../Condition'

module.exports = flow.model 'Flow',
  schema:
    action:
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

  listen: ->
    [app_uid, action_uid] = @action.split '.'
    action = home.apps[app_uid]?.actions?[action_uid]

    home.feeds.flow @trigger, (args) =>
      # TODO defaultify the args before doing the conditions
      for condition in @conditions
        unless condition.test args
          return "TODO condition failed"

      action args
