require 'em-http'
require 'em-http/middleware/oauth'
require 'json'

module SparkDemoTwitterbot
  class TwitterStream
    ENDPOINT = 'https://stream.twitter.com/1.1/statuses/filter.json'
    OAUTH_CONFIG = {
      consumer_key:         ENV['OAUTH_CONSUMER_KEY'],
      consumer_secret:      ENV['OAUTH_CONSUMER_SECRET'],
      access_token:         ENV['OAUTH_ACCESS_TOKEN'],
      access_token_secret:  ENV['OAUTH_ACCESS_TOKEN_SECRET']
    }

    def initialize(track_term, &tweet_handler)
      @tweet_handler = tweet_handler
      connection = EM::HttpRequest.new ENDPOINT, { inactivity_timeout: 90 }
      connection.use EM::Middleware::OAuth, OAUTH_CONFIG
      request_options = { body: { track: track_term },
                          keepalive: true }
      client = connection.post request_options
      client.stream &method(:stream)
      client.callback &method(:callback)
      client.errback &method(:errback)
    end

    def stream(chunk)
      @buffer ||= ''
      @buffer << chunk
      while line = @buffer.slice!(/.+\r\n/)
        @tweet_handler.call JSON.parse(line)
      end
    end

    def callback(client)
      puts 'connection closed'
      if 401 == client.response_header.status
        puts '   *** 401 Unauthorized ***'
        puts '   *** You need to set the OAUTH environment vars correctly.'
      else
        puts 'buffer contents:'
        puts @buffer
      end
      EM.stop # or, actually, reconnect
    end

    def errback(client)
      puts 'fail'
      EM.stop # find out why, back off, reconnect
    end
  end
end
