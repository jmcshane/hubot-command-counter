# Hubot Command Counter

This module implements the Hubot middleware pattern to count the number of times each command is called.  It uses the brain to store this information so that it can be persisted if desired.

## Installation

In order to install the hubot counter, first install the package:

    npm install --save hubot-command-counter

Then, add the counter to the `external-scripts.json` file at the root of your project.

    [
      "hubot-command-counter"
    ]

## Configuration

If you are using a brain that requires the save event in order to persist the brain data, set the environment variable `HUBOT_COMMAND_COUNTER_SAVE_PERIOD`.  This will trigger the brain save event with this period value in seconds.  If this value is not set, the save event is not triggered by this middleware.

## Listener Configuration

Within hubot, there are not good ways to identify listeners.  In order to get better identifiers, an option parameter was added to all the `robot.*` functions.  This middleware defines a `counterId` option that will allow each command to be named nicely.

    robot.respond /test post please ignore/, {commandId: test-post}, (msg) ->

## Accessing Counts

Once the commands are aliased as above, these counts can be accessed using the following command

    count-middleware <counterId>

If no counterId is provided, the counts for all recorded commands will be listed.