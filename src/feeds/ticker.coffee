flow = require '../flow'

flow.feed 'ticker',
  name: "Tick Feed"
  info: """
    The callback is the subscription closure.
    It should return an unsubscribe function.

    This ticker gives the time every second.
  """
  , (callback) ->
    interval = setInterval ->
      callback time: new Date().getTime()
    , 1000

    -> clearInterval interval
