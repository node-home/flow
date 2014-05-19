# events = require 'events'
home   = require 'home'

events    =
  EventEmitter: require('eventemitter2').EventEmitter2

module.exports = home.app module,
  name: "Flow"
  info: """
    The flow of triggers and actions in home.
  """
, (app) ->
  app.hub = new events.EventEmitter

  app.feeds = require './feeds'
  # TODO load all flow sinks and connect them to the flow feed
