require 'facebook/messenger'

Facebook::Messenger.configure do |config|
  config.access_token = 'EAACkDXnXwbsBANop2ckai0RITPPZCImkeRR2dzSFnCTzLoJa8V2WHq8xU1vkEzlafTZCaUCvRxnZBN0ZAYg3LjUafndffIe8N6Px3NGzZCsWcwZCkXfZBwq1qhZBMRbb7phoOHzIdQbsMVpxbBmXoZBdcdH4G7apitLZBYIWZBbFBZB7MQZDZD'
  config.verify_token = 'password'
end

include Facebook::Messenger

Bot.on :message do |message|
  puts "Received #{message.text} from #{message.sender}"

  case message.text

  when /hello/i
    Bot.deliver(
      recipient: message.sender,
      message: {
        text: 'Hello, human!'
      }
    )

  when /salut/i
    Bot.deliver(
      recipient: message.sender,
      message: {
        text: 'Hello, humain!'
      }
    )

  when /Comment tu vas ?/i
    Bot.deliver(
      recipient: message.sender,
      message: {
        text: 'Ca va nickel et toi ?'
      }
    )

  when /top/i
    Bot.deliver(
      recipient: message.sender,
      message: {
        text: 'Cool !'
      }
    )
    Bot.deliver(
      recipient: message.sender,
      message: {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'button',
            text: 'Do you want to see somthing cool ?',
            buttons: [
              { type: 'postback', title: 'Yes', payload: 'HUMAN_AGREE' },
              { type: 'postback', title: 'No', payload: 'HUMAN_DISAGREE' }
            ]
          }
        }
      }
      )

  when /something humans like/i
    Bot.deliver(
      recipient: message.sender,
      message: {
        text: 'I found something humans seem to like:'
      }
      )

    Bot.deliver(
      recipient: message.sender,
      message: {
        attachment: {
          type: 'image',
          payload: {
            url: 'https://i.imgur.com/iMKrDQc.gif'
          }
        }
      }
      )

    Bot.deliver(
      recipient: message.sender,
      message: {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'button',
            text: 'Did human like it?',
            buttons: [
              { type: 'postback', title: 'Yes', payload: 'HUMAN_LIKED' },
              { type: 'postback', title: 'No', payload: 'HUMAN_DISLIKED' }
            ]
          }
        }
      }
      )
  else
    Bot.deliver(
      recipient: message.sender,
      message: {
        text: "Sorry I don't understand you..."
      }
      )

    Bot.deliver(
      recipient: message.sender,
      message: {
        text: 'Have a nice day.'
      }
      )
  end
end

Bot.on :postback do |postback|
  case postback.payload
  when 'HUMAN_LIKED'
    text = 'That makes Moni happy!'
  when 'HUMAN_DISLIKED'
    text = 'Oh.'
  end

  Bot.deliver(
    recipient: postback.sender,
    message: {
      text: text
    }
    )
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end

Bot.on :delivery do |delivery|
  delivery.ids       # => 'mid.1457764197618:41d102a3e1ae206a38'
  delivery.sender    # => { 'id' => '1008372609250235' }
  delivery.recipient # => { 'id' => '2015573629214912' }
  delivery.at        # => 2016-04-22 21:30:36 +0200
  delivery.seq       # => 37

  puts "Human was online at #{delivery.at}"
end
