WEEKDAYS = [
  'Monday'
  'Tuesday'
  'Wednesday'
  'Thursday'
  'Friday'
  'Saturday'
  'Sunday'
]

flow.condition 'timeframe', ->
  name: 'Timeframe'
  info: """
    Describes a time window in which the condition passes.
  """
  schema:
    begin:
      type: 'time'
    end:
      type: 'time'
    date:
      type: 'date'
    weekdays:
      type: ['string']
      choices: WEEKDAYS
    params:
      timestamp:
        type: 'date'
        default: -> new Date
, ({date}) ->
  return false if @date and not @date.toDateString() == timestamp.toDateString()
  return false if @weekdays and not WEEKDAYS[timestamp.getDay()] in @weekdays
  # TODO these are pseudo
  return false if @begin and timestamp < @begin
  return false if @end and timestamp > @end

  true
