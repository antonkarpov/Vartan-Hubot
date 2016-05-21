# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
https = require('follow-redirects').https

module.exports = (robot) ->
  	  robot.respond /(order|добавить|добавь|хочу|o) (.*) за ([\d]*)/i, (msg) ->
  	    try
          sender = get_username(msg)
        catch error
          sender = "Братишка"

        name = msg.match[2].trim()

        if name.length == 0
          msg.send sender + 
          ", дорогой, ты уж скажи, что ты хочешь заказать? Советую - 'добавить шашлык со свининой в лаваше за 110'"
          return

        price = msg.match[3].trim()

        if price.length == 0
          msg.send sender + ", дорогой, цену указать не забудь. Советую - 'добавить шашлык со свининой в лаваше за 110'"
        else

          dudes = robot.brain.get('food_order_dudes') or {}
          dude_order = dudes[sender] or []

          new_item = {}
          new_item["name"] = name
          new_item["price"] = price

          try
            dude_order.push new_item
            dudes[sender] = dude_order
            robot.brain.set('food_order_dudes', dudes)
            msg.send(sender + ", *" + name + "* за "+ price + "р - добавлено к заказу")
          catch
            msg.send(sender + ", *" + name + "* за "+ price + "р - не в силах добавить, сожалею")


      robot.respond /(show|s|покажи) (order|o|заказ)/i, (msg) ->
        try
          sender = get_username(msg)
        catch error
          sender = "Братишка"

        my_order = msg.match[2].trim()

        try
          dudes = robot.brain.get('food_order_dudes')
        catch e
          dudes = {}

        order_string = sender

        if my_order.length == 0
          order_string += ", вот весь заказ : \n"
          for d, d_order of dudes
            if d_order.length > 0
              order_string += d + ":\n"
              for item in d_order
                order_string += item["name"] + " - " + item["price"] + "\n"
        else
          try
            dude_order = dudes[sender]
          catch e
            dude_order = []

          if dude_order.length > 0
            order_string += ", вот твой заказ : \n"
            order_string += sender + ":\n"
            for item in dude_order
              order_string += item["name"] + " - " + item["price"] + "\n"
          else
            order_string += ", не заказывал ты ничего пока"
          
        msg.send order_string


      robot.respond /(show|покажи) (total|сумму)/i, (msg) ->
        try
          sender = get_username(msg)
        catch error
          sender = "Братишка"

        sum = msg.match[2].trim()

        if sum.length == 0
          msg.send sender + ", общая цена заказа - {price}р"
        else   
          msg.send sender + ", сумма твоего заказа - {price}p"


      robot.respond /Хочу есть/i, (msg) ->
        msg.send 'Кушай, дорогой'
        https.get 'https://script.google.com/macros/s/AKfycbxiyTu9Vfkd2KQGbvwSd3ZJCiKPM5mYEnsYr4-uVTzzfkulX1C6/exec', (res) ->
          res.on 'data', (chunk) ->
            msg.send chunk;

  #   doorType = res.match[1]
  #   if doorType is "pod bay"
  #     res.reply "I'm afraid I can't let you do that."
  #   else
  #     res.reply "Opening #{doorType} doors"
  #
  # robot.hear /I like pie/i, (res) ->
  #   res.emote "makes a freshly baked pie"
  #
  # lulz = ['lol', 'rofl', 'lmao']
  #
  # robot.respond /lulz/i, (res) ->
  #   res.send res.random lulz
  #
  # robot.topic (res) ->
  #   res.send "#{res.message.text}? That's a Paddlin'"
  #
  #
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  #
  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  #
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  #
  # robot.respond /what is the answer to the ultimate question of life/, (res) ->
  #   unless answer?
  #     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   res.send "#{answer}, but what is the question?"
  #
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  # annoyIntervalId = null
  #
  # robot.respond /annoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  #
  #   res.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  #
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, res) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if res?
  #     res.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  #
  #   else
  #     res.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
