events = require 'events'
home   = require 'home'

module.exports = home.app module,
  name: "Flow"
  info: """
    The flow of triggers and actions in home.
  """
, (app) ->
  app.hub = new events.EventEmitter
