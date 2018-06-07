class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          if event.message['text'].include?('Twitter') ||  event.message['text'].include?('ツイッター')
            message = {
              type: 'text',
              text: "ツイッターが含まれていたよ"
              # text: event.message['text']
            }
          else
            last_id = Seed.last.id
            seed1_id = rand(last_id) + 1
            seed2_id = rand(last_id) + 1
            while seed1_id == seed2_id
              seed2_id = rand(last_id) + 1
            end
            message = {[
              type: 'text',
              text: "#{Seed.find(seed1_id).content} × #{Seed.find(seed2_id).content} !!"
            ],[
              type: 'text',
              text: "Twitter投稿はこちらから→https://ideatweet.herokuapp.com/twitter/#{Post.last.id}"
            ]
            }
          end
          client.reply_message(event['replyToken'], message)
        end
      end
    }

    head :ok
  end
end
