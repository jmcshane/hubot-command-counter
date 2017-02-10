module.exports = (robot) ->

  robot.hear /debug counter/, {counterId: "debug-counter"}, (msg) ->
    msg.reply "first"

  robot.hear /debug ctr without ID/, (msg) ->
    msg.reply "second"  