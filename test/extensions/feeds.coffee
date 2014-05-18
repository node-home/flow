events = require 'events'
nock   = require 'nock'
io     =
  server: require 'socket.io'
  client: require 'socket.io-client'

feeds  = require '../../src/extensions/feeds'
helpers = require '../../src/helpers'

describe 'helpers', ->
  @timeout 1500

  emitter = null
  subscribers = null
  fire = null

  createNock = ->
    nock 'http://test.local'
    .filteringRequestBody /.*/, '*'
    .post '/endpoint', '*'

  beforeEach ->
    emitter = new events.EventEmitter
    subscribers = helpers.buildSubscribers 'test', emitter
    fire = ->
      emitter.emit 'test', test: true

  describe 'buildSubscribers()', ->

    describe 'callback', ->
      it 'should support callbacks', ->
        subscribers.should.have.property 'callback'

      it 'should connect via callback', (done) ->
        callback = (args) ->
          args.should.containEql test: true
          done()
        subscribers.callback callback
        fire()

      it 'should disconnect via callback', (done) ->
        callback = (args) ->
          should.fail 'does not unregister callbacks'
        stop = subscribers.callback callback
        stop()
        fire()
        setTimeout done, 100

    describe 'endpoint', ->
      nocks = null

      beforeEach ->
        nocks = createNock()

      afterEach ->
        nock.cleanAll()

      it 'should support endpoints', ->
        subscribers.should.have.property 'endpoint'

      it 'should support https'

      it 'should register endpoints', (done) ->
        nocks.reply 200, (uri, requestBody) ->
          JSON.parse(requestBody).should.containEql test: true
          done()
        subscribers.endpoint 'http://test.local/endpoint'
        fire()

      it 'should unregister endpoints', (done) ->
        nocks.reply 200, (uri, requestBody) ->
          done 'did not unregister endpoint'
        stop = subscribers.endpoint 'http://test.local/endpoint'
        stop()
        fire()
        setTimeout done, 100

    describe 'websocket', ->
      socket = null

      beforeEach ->
        socket = io.server.listen 5000, log: false

      afterEach ->
        socket.server.close()

      it 'should support websockets', ->
        subscribers.should.have.property 'websocket'

      it 'should register websockets', (done) ->
        socket.sockets.on 'connection', (client) ->
          client.on 'test', (args) ->
            args.should.containEql test: true
            done()

          fire()

        subscribers.websocket 'http://localhost:5000'

      it 'should unregister websockets', (done) ->
        socket.sockets.on 'connection', (client) ->
          client.on 'test', (args) ->
            should.fail 'did not unregister websocket'

          fire()
          setTimeout done, 100

        stop = subscribers.websocket 'http://localhost:5000'
        stop()

  describe 'buildEndpoint()', ->
    endpoint = null

    beforeEach ->
      endpoint = helpers.buildEndpoint 'test', subscribers

    describe '.socket', ->
      socket = null

      beforeEach ->
        socket = io.server.listen 5000, log: false

      afterEach ->
        socket.server.close()

      it 'should register sockets', (done) ->
        socket.sockets.on 'connection', (client) ->
          client.on 'test', (args) ->
            args.should.containEql test: true
            done()
          fire()
        endpoint socket: 'http://localhost:5000'

      it 'should unregister sockets', (done) ->
        socket.sockets.on 'connection', (client) ->
          client.on 'test', (args) ->
            done 'did not unregister socket'
          stop()
          fire()
          setTimeout done, 100
        stop = endpoint socket: 'http://localhost:5000'

    describe '.endpoint', ->
      nocks = null

      beforeEach ->
        nocks = createNock()

      afterEach ->
        nock.cleanAll()

      it 'should register endpoints', (done) ->
        nocks.reply 200, (uri, requestBody) ->
          JSON.parse(requestBody).should.containEql test: true
          done()
        stop = subscribers.endpoint 'http://test.local/endpoint'
        fire()

      it 'should unregister endpoints', (done) ->
        nocks.reply 200, (uri, requestBody) ->
          done 'did not unregister endpoint'
        stop = subscribers.endpoint 'http://test.local/endpoint'
        stop()
        fire()
        setTimeout done, 100

describe 'feeds', ->
  describe 'extension', ->
    it 'should return a function'
