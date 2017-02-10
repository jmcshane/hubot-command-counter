# Description
#   Middleware for counting the number of times each command is called
#
# Configuration:
#   HUBOT_COMMAND_COUNTER_SAVE_PERIOD - how frequently to emit the save event to persist the data (optional, save not called if not set)
#
# Commands:
#   count-middleware <key> - gets the current counter data with an optional key
#
# Notes
#   This middleware uses the robot brain to save how often each command is called.
#   The regex is a bad way to save this, so an option can be set in the respond function definition
#   e.g. robot.respond /test/, {counterId: 'my-pretty-string'}, (msg)->
#
# Author:
#   jmcshane <jmcshan1@gmail.com>

pretty = require 'prettyjson'

COUNTER_KEY = 'listener-counter-key'
savePeriod = parseInt(process.env.HUBOT_COMMAND_COUNTER_SAVE_PERIOD) * 1000
module.exports = (robot) ->

  if savePeriod
    setTimeout(f = (->
      robot.brain.save()
      setTimeout(f, savePeriod)
    ), savePeriod)

  robot.respond "/count-middleware(?: (.*))?/", (msg) ->
    counts = robot.brain.get(COUNTER_KEY)
    if msg.match[1]
      msg.reply counts[msg.match[1]]
    else
      msg.send "/code #{pretty.render counts}"

  robot.listenerMiddleware (context, next, done) ->
    # The regex is often ugly, so provide an ability to set counterId
    listenerKey = context.listener.options?.counterId or context.listener.regex.toString()
    return unless listenerKey?
    try
      listenerData = robot.brain.get(COUNTER_KEY) or {}
      listenerData[listenerKey] = (listenerData[listenerKey] or 0) + 1
      robot.brain.set(COUNTER_KEY, listenerData)
      next done