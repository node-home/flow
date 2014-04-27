###
 * Conditions are functions that return truthy if they pass
###
home = require 'home'

module.exports = home.apps.flow.model 'Condition',
  schema:
    name:
      type: String
      required: yes
    uid:
      type: String
      required: yes
    args:
      type: {}
    flow:
      type: 'flow.Flow'
      required: yes

  test: (args) ->
    [app_uid, condition_uid] = @uid.split '.'
    home.apps[app_uid]?.conditions?[condition_uid] args
