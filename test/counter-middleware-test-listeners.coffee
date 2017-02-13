module.exports = (robot) ->

  robot.hear /debug counter/, {id: "debug-counter"}, (msg) ->
    msg.reply "first"

  robot.hear /debug ctr without ID/, (msg) ->
    msg.reply "second"  