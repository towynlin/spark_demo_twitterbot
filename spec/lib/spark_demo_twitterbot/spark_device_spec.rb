require 'spark_demo_twitterbot/spark_device'

describe SparkDemoTwitterbot::SparkDevice do
  subject { SparkDemoTwitterbot::SparkDevice.new('foo') }

  it 'is initialized with a device id' do
    expect(subject).to be_a SparkDemoTwitterbot::SparkDevice
  end
  it 'responds to handle_tweet' do
    expect(subject).to respond_to :handle_tweet
  end
  it 'responds to handle_retweet' do
    expect(subject).to respond_to :handle_retweet
  end
  it 'responds to brighten' do
    expect(subject).to respond_to :brighten
  end
  it 'reponds to blink' do
    expect(subject).to respond_to :blink
  end

  context '#handle_tweet' do
    it 'does nothing if the user has 7 followers' do
      subject.should_not_receive(:brighten)
      subject.handle_tweet(7)
    end
    it 'brightens the light by 1 if the user has 16 followers' do
      subject.should_receive(:brighten).with(1)
      subject.handle_tweet(16)
    end
    it 'brightens the light by 2 if the user has 32 followers' do
      subject.should_receive(:brighten).with(2)
      subject.handle_tweet(32)
    end
    it 'brightens the light by 3 if the user has 64 followers' do
      subject.should_receive(:brighten).with(3)
      subject.handle_tweet(64)
    end
  end

  context '#handle_retweet' do
    it 'does nothing if the total number of followers is 49' do
      subject.should_not_receive(:blink)
      subject.handle_retweet(49)
    end
    it 'blinks the light by 1 if the total number of followers is 100' do
      subject.should_receive(:blink).with(1)
      subject.handle_retweet(100)
    end
    it 'blinks the light by 2 if the total number of followers is 200' do
      subject.should_receive(:blink).with(2)
      subject.handle_retweet(200)
    end
    it 'blinks the light by 3 if the total number of followers is 400' do
      subject.should_receive(:blink).with(3)
      subject.handle_retweet(400)
    end
  end

  context '#brighten' do
  end

  context '#blink' do
  end
end
