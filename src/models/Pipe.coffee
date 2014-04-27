home      = require 'home'
flow      = require '../flow'

module.exports = flow.model 'Pipe',
  schema:
    feed:
      type: String
      required: yes
    sink:
      type: String
      required: yes
    name:
      type: String
      required: yes

  listen: (args) ->
    [app_uid, feed_uid] = @feed.split '.'
    feed = home.apps[app_uid]?.feeds?[feed_uid]

    [app_uid, sink_uid] = @sink.split '.'
    sink = home.apps[app_uid]?.sinks?[sink_uid]

    # TODO
    # - Set up te sink?
    # - Singleton?
    # - Flow is a special Pipe?
    # - Return the function to off the pipe
    feed sink args
