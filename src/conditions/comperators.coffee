flow = require '../flow'

flow.condition 'regex',
  info: """
    Test a string against a regex.
  """
  schema:
    eq: Number
    neq: Number
    lt: Number
    lte: Number
    gt: Number
    gte: Number
  params:
    input:
      type: Number
      required: yes
  , ({input}) ->
    return false if @eq?  and not input == @eq
    return false if @neq? and not input != @neq
    return false if @lt?  and not input < @lt
    return false if @lte? and not input <= @lte
    return false if @gt?  and not input > @gt
    return false if @gte? and not input >= @gte
    true
