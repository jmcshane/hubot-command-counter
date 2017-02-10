expect = require('chai').expect

Robot = require 'hubot/src/robot'
TextMessage = require('hubot/src/message').TextMessage

#helper = new Helper '../src/counter-middleware.coffee'

COUNTER_KEY = 'listener-counter-key'

process.env.HUBOT_COMMAND_COUNTER_SAVE_PERIOD = "1"

describe 'counter-middleware', ->
  robot = {}
  adapter = {}
  middleware = {}
  user = {}


  before (done) ->
    robot = new Robot null, "mock-adapter", false

    robot.adapter.on "connected", ->
      require("../src/counter-middleware")(@robot)
      require("../test/counter-middleware-test-listeners")(@robot)
      user = robot.brain.userForId '1', {
        name: 'user'
        room: '#test'
      }

      adapter = robot.adapter
      middleware = robot.middleware

    robot.run()
    done()

  after ->
    robot.shutdown()

  it 'should call robot brain save in the timeout', (done) ->
    complete = false
    robot.brain.on 'save', =>
      if !complete
        complete=true
        done()

  it 'sets the key based on the counterId options', (done) ->
    adapter.receive(new TextMessage user, "debug counter")

    adapter.on "reply", (envelope, strings) ->
      if strings[0] is "first"
        expect(robot.brain.get(COUNTER_KEY)["debug-counter"]).to.eql(1)
        done()

  it 'if the counterId is not present, sets the key based on the regex', (done) ->
    adapter.receive(new TextMessage user, "debug ctr without ID")

    adapter.on "reply", (envelope, strings) ->
      if strings[0] is "second"
        expect(robot.brain.get(COUNTER_KEY)['/debug ctr without ID/']).to.eql(1)
        done()