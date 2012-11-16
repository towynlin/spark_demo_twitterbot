require 'spark_demo_twitterbot/spark_device'

describe SparkDemoTwitterbot::SparkDevice do
  subject { SparkDemoTwitterbot::SparkDevice.new('foo') }

  before :each do
    # don't actually sleep during tests
    subject.stub(:sleep)
  end

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
  it 'responds to blink' do
    expect(subject).to respond_to :blink
  end
  it 'responds to fade' do
    expect(subject).to respond_to :fade
  end
  it 'responds to current_level' do
    expect(subject).to respond_to :current_level
  end

  context '#handle_tweet' do
    it 'brightens the light by 3 if the user has 0 followers' do
      subject.should_receive(:brighten).with(3)
      subject.handle_tweet(0)
    end
    it 'brightens the light by 4 if the user has 16 followers' do
      subject.should_receive(:brighten).with(4)
      subject.handle_tweet(16)
    end
    it 'brightens the light by 5 if the user has 32 followers' do
      subject.should_receive(:brighten).with(5)
      subject.handle_tweet(32)
    end
    it 'brightens the light by 6 if the user has 64 followers' do
      subject.should_receive(:brighten).with(6)
      subject.handle_tweet(64)
    end
  end

  context '#handle_retweet' do
    it 'blinks the light by 3 if the total number of followers is 0' do
      subject.should_receive(:blink).with(3)
      subject.handle_retweet(0)
    end
    it 'blinks the light by 3 if the total number of followers is 40' do
      subject.should_receive(:blink).with(3)
      subject.handle_retweet(40)
    end
    it 'blinks the light by 4 if the total number of followers is 80' do
      subject.should_receive(:blink).with(4)
      subject.handle_retweet(80)
    end
    it 'blinks the light by 5 if the total number of followers is 160' do
      subject.should_receive(:blink).with(5)
      subject.handle_retweet(160)
    end
  end

  context '#should_ignore?' do
    context 'less than a second ago' do
      it 'is true for magnitude 2' do
        expect(subject.should_ignore?(2)).to be_true
      end
    end
    context 'more than a second ago' do
      before :all do
        @device_having_waited = subject
        sleep 1.1
      end
      it 'is true for magnitude 0' do
        expect(@device_having_waited.should_ignore?(0)).to be_true
      end
      it 'is false for magnitude 2' do
        expect(@device_having_waited.should_ignore?(2)).to be_false
      end
    end
  end

  context '#brighten' do
    it 'checks the current level, fades up quickly, then down slowly' do
      subject.should_receive(:should_ignore?).once.and_return(false)
      subject.should_receive(:current_level).once.and_return(2)
      subject.brighten(1)
    end
    it 'does nothing for magnitude 0' do
      subject.should_receive(:should_ignore?).once.and_return(true)
      subject.should_not_receive(:current_level)
      subject.brighten(0)
    end
  end

  context '#blink' do
    it 'checks the current level, and fades quickly up, down, up, then down slowly' do
      subject.should_receive(:should_ignore?).once.and_return(false)
      subject.should_receive(:current_level).once.and_return(2)
      subject.blink(1)
    end
    it 'does nothing for magnitude 0' do
      subject.should_not_receive(:current_level)
      subject.blink(0)
    end
  end

  context '#fade' do
    before :each do
      client = double('client').as_null_object
      client.should_receive(:callback).and_yield
      EM::HttpRequest.stub_chain(:new, :put).and_return(client)
    end
    it 'calls a given block' do
      @called = false
      subject.fade(0, 1) { @called = true }
      expect(@called).to be_true
    end
    it 'is ok not to pass a block' do
      expect(subject.fade(0, 1)).not_to raise_error
    end
  end

  context '#current_level' do
  end
end
