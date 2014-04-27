flow = require '../flow'

flow.condition 'regex',
  info: """
    Test a string against a regex.
  """
  schema:
    pattern:
      type: String
      required: yes
    flags:
      type: String
      required: yes
  params:
    input:
      type: String
      required: yes
  , ({input}) ->
    new RegExp(@pattern, @flags).test input
