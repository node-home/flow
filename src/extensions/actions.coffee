home = require 'home'
flow = require '../'

module.exports = flow.extension 'action',
  name: 'Action'
  info: """
    An action is a function that is available in the home
    environment by its identifier. It is also exposed by
    its endpoint.

    The parameters to the endpoint are validated by the spec.
  """
  method: 'POST'
  , home.endpoint


flow.action 'example',
  name: 'Example Action'
  info: """
    Actions are just javascript functions that can do anything.
    Input is sanitized by the params object.
  """
  params:
    requiredParam:
      type: 'string'
      required: yes
    defaultedParam:
      type: 'integer'
      default: 0
    validatedParam:
      type: 'string'
  , (args) ->
    console.log args.requiredParam
    console.log args.defaultedParam
    console.log args.validatedParam
