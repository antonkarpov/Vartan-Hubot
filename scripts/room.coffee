# helper method to get sender of the message
      get_username = (response) ->
        "@#{response.message.user.name}"
 
      # helper method to get channel of originating message
      get_channel = (response) ->
        if response.message.room == response.message.user.name
          "@#{response.message.room}"
        else
          "##{response.message.room}"