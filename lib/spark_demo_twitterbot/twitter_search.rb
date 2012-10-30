require 'em-http'
require 'em-http/middleware/oauth'
require 'json'

module SparkDemoTwitterbot
  class TwitterSearch
    ENDPOINT = 'https://api.twitter.com/1.1/search/tweets.json'
    OAUTH_CONFIG = {
      consumer_key:         ENV['OAUTH_CONSUMER_KEY'],
      consumer_secret:      ENV['OAUTH_CONSUMER_SECRET'],
      access_token:         ENV['OAUTH_ACCESS_TOKEN'],
      access_token_secret:  ENV['OAUTH_ACCESS_TOKEN_SECRET']
    }

    def initialize(track_term)
      @request_options = { query: { q: track_term, count: 10 },
                           head: { 'accept-encoding' => 'gzip' } }
    end

    def get(&tweet_handler)
      @tweet_handler = tweet_handler
      connection = EM::HttpRequest.new ENDPOINT
      connection.use EM::Middleware::OAuth, OAUTH_CONFIG
      client = connection.get @request_options
      client.callback &method(:callback)
      client.errback &method(:errback)
    end

    def callback(client)
      if 401 == client.response_header.status
        puts '   *** 401 Unauthorized ***'
        puts '   *** You need to set the OAUTH environment vars correctly.'
      else
        @tweet_handler.call JSON.parse(client.response)
      end
    end

    def errback(client)
      puts 'fail'
      EM.stop # find out why, back off, reconnect
    end
  end
end
