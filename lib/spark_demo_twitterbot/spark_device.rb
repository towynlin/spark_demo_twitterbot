module SparkDemoTwitterbot
  class SparkDevice
    def initialize(device_id)
      @device_id = device_id
      @last_fall_duration = 0
      @last_fall_time = Time.now
    end

    def handle_tweet(followers_count)
      return if 16 > followers_count
      magnitude = Math.log2(followers_count / 8)
      brighten(magnitude.round)
    end

    def handle_retweet(followers_count)
      return if 100 > followers_count
      magnitude = Math.log2(followers_count / 50)
      blink(magnitude.round)
    end

    def brighten(magnitude)
      return if 1 > magnitude
      puts "brighten #{magnitude}"
      level = current_level + magnitude
      duration_seconds = magnitude * 0.1
      fade level, duration_seconds
      sleep duration_seconds
      @last_fall_duration = level * 30
      @last_fall_time = Time.now
      fade 0, @last_fall_duration
    end

    def blink(magnitude)
      return if 1 > magnitude
      puts "blink #{magnitude}"
      level = current_level
      fade level + magnitude, 0.3
      sleep 0.3
      fade level - magnitude, 0.3
      sleep 0.3
      level += magnitude / 3
      fade level, 0.3
      sleep 0.3
      seconds_remaining = @last_fall_time + @last_fall_duration - Time.now
      @last_fall_duration = level * 30
      if 0 < seconds_remaining
        @last_fall_duration += seconds_remaining
      end
      @last_fall_time = Time.now
      fade 0, @last_fall_duration
    end

    def fade(target, duration_seconds)
      target = validated_target(target)
      duration_seconds = validated_duration(duration_seconds)
      duration_ms = (1000 * duration_seconds).to_i
      resource = "#{ENV['SPARK_API_PROTO_HOST']}/devices/#{@device_id}/fade/#{target}/#{duration_ms}"
    end

    def current_level
      resource = "#{ENV['SPARK_API_PROTO_HOST']}/devices/#{@device_id}/getStatus"
      5
    end

    def validated_target(target)
      unless target.is_a? Integer
        if target.respond_to? :to_i
          target = target.to_i 
        else
          raise TypeError.new "can't convert #{target.class} into Integer"
        end
      end
      target = 0 if 0 > target
      target = 12 if 12 < target
      target
    end
  end

  def validated_duration(duration_seconds)
    unless duration_seconds.is_a? Numeric
      if duration_seconds.respond_to? :to_f
        duration_seconds = duration_seconds.to_f
      else
        raise TypeError.new "can't convert #{duration_seconds.class} into Numeric"
      end
    end
    duration_seconds = 0 if 0 > duration_seconds
    duration_seconds = 600 if 600 < duration_seconds
    duration_seconds
  end
end
