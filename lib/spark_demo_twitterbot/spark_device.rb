module SparkDemoTwitterbot
  class SparkDevice
    def initialize(device_id)
      @device_id = device_id
    end

    def handle_tweet(followers_count)
      return if 16 > followers_count
      magnitude = Math.log2(followers_count >> 3)
      brighten(magnitude.round)
    end

    def handle_retweet(followers_count)
      return if 100 > followers_count
      magnitude = Math.log2(followers_count / 50)
      blink(magnitude.round)
    end

    def brighten(magnitude)
      puts "brighten #{magnitude}"
    end

    def blink(magnitude)
      puts "blink #{magnitude}"
    end
  end
end
