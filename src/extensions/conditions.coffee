home = require 'home'
base = require 'home.base'

home.App::condition = (uid, options, func) ->
  @conditions ?= {}

  @options.method = 'GET'
  @options.url ?= "//home.local/#{@uid}/conditions/#{uid}"
  @options.uid = "#{@uid}.#{uid}"

  @actions[uid] = base.schemaFunction options.params, func

flow.extension 'conditions', ->
  info: """
    Conditions are functions that test circumstances and
    return whether they pass.
  """
