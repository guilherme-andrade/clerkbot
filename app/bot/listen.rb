require "facebook/messenger"
require "facebook/bot/util"


include Facebook::Messenger

#Facebook::Messenger::Subscriptions.subscribe(access_token: ENV['FB_ACCESS_TOKEN'])

Facebook::Messenger::Profile.set({
  greeting: [
    {
      locale: 'default',
      text: 'Welcome to your new bot overlord!'
    },
    {
      locale: 'fr_FR',
      text: 'Bienvenue dans le bot du Wagon !'
    }
  ]
}, access_token: ENV['FB_ACCESS_TOKEN'])


Facebook::Messenger::Profile.set({
  get_started: {
    payload: 'home'
  }
}, access_token: ENV['FB_ACCESS_TOKEN'])

Facebook::Messenger::Profile.set({
  persistent_menu: [
    {
      locale: 'default',
      composer_input_disabled: false,
      call_to_actions: [
        {
          title: 'My Account',
          type: 'nested',
          call_to_actions: [
            {
              title: 'What\'s a chatbot?',
              type: 'postback',
              payload: 'EXTERMINATE'
            },
            {
              title: 'History',
              type: 'postback',
              payload: 'HISTORY_PAYLOAD'
            },
            {
              title: 'Contact Info',
              type: 'postback',
              payload: 'CONTACT_INFO_PAYLOAD'
            }
          ]
        },
        {
          type: 'web_url',
          title: 'Get some help',
          url: 'https://github.com/hyperoslo/facebook-messenger',
          webview_height_ratio: 'full'
        }
      ]
    },
    {
      locale: 'zh_CN',
      composer_input_disabled: false
    }
  ]
}, access_token: ENV['FB_ACCESS_TOKEN'])

# Make the bot act on received message
Bot.on :message do |message|
  p message
  message.mark_seen
  message.typing_on
  answer = Brain.new(message).select_answer
  message.reply(answer)
  # message.reply(
  #   text: "answer",
  #   quick_replies: [
  #     {
  #       content_type: 'text',
  #       title: 'You are!',
  #       payload: 'HARMLESS'
  #     }
  #   ]
  # )
  message.typing_off
  p answer
end


# Make the bot act if user selected option
Bot.on :postback do |postback|
  p postback
  postback.mark_seen
  postback.typing_on
  answer = Brain.new(postback).select_answer
  postback.reply(answer)
  postback.typing_off
  p answer
end


# # Keep track of messages sent to user
# Bot.on :message_echo do |message_echo|
#   message_echo.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
#   message_echo.sender      # => { 'id' => '1008372609250235' }
#   message_echo.seq         # => 73
#   message_echo.sent_at     # => 2016-04-22 21:30:36 +0200
#   message_echo.text        # => 'Hello, bot!'
#   message_echo.attachments # => [ { 'type' => 'image', 'payload' => { 'url' => 'https://www.example.com/1.jpg' } } ]
# end

# # Keep track of message requests accepted by the user
# Bot.on :message_request do |message_request|
#   message_request.accept? # => true

#   # Log or store in your storage method of choice (skynet, obviously)
# end

# # Received when user clicks on m.me links on a website
# Bot.on :optin do |optin|
#   optin.sender    # => { 'id' => '1008372609250235' }
#   optin.recipient # => { 'id' => '2015573629214912' }
#   optin.sent_at   # => 2016-04-22 21:30:36 +0200
#   optin.ref       # => 'CONTACT_SKYNET'

#   optin.reply(text: 'Ah, human!')
# end


# # Used to stalk the user
# Bot.on :delivery do |delivery|
#   delivery.ids       # => 'mid.1457764197618:41d102a3e1ae206a38'
#   delivery.sender    # => { 'id' => '1008372609250235' }
#   delivery.recipient # => { 'id' => '2015573629214912' }
#   delivery.at        # => 2016-04-22 21:30:36 +0200
#   delivery.seq       # => 37

#   puts "Human was online at #{delivery.at}"
# end


# # When a user follors an m.me, a referral can be received in the params
#   # http://m.me/mybot?ref=myparam
# Bot.on :referral do |referral|
#   referral.sender    # => { 'id' => '1008372609250235' }
#   referral.recipient # => { 'id' => '2015573629214912' }
#   referral.sent_at   # => 2016-04-22 21:30:36 +0200
#   referral.ref       # => 'MYPARAM'
# end

