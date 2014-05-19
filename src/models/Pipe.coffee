home      = require 'home'
flow      = require '../flow'

module.exports = home.model 'Pipe',
  info: """
    A pipe streams data from a feed into a sink.
  """
  schema:
    feed_id:
      type: String
      info: """
        The write end of the pipe
      """
      required: yes
    sink_id:
      type: String
      info: """
        The read end of the pipe
      """
      required: yes
    name:
      type: String
      required: yes

  virtuals:
    feed: ->
      [app_uid, feed_uid] = @feed_id.split '.'
      home.apps[app_uid]?.feeds?[feed_uid]

    sink: ->
      [app_uid, sink_uid] = @sink_id.split '.'
      home.apps[app_uid]?.sinks?[sink_uid]

  methods:
    listen: (args) ->
      # TODO
      # - Set up te sink?
      # - Singleton?
      # - Flow is a special Pipe?
      # - Return the function to off the pipe
      @feed callback: @sink args
