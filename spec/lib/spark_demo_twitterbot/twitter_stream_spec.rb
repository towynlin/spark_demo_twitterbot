require 'spark_demo_twitterbot/twitter_stream'

describe SparkDemoTwitterbot::TwitterStream do
  it 'raises an ArgumentError when initialized with no arguments' do
    expect { SparkDemoTwitterbot::TwitterStream.new }.to raise_error(ArgumentError)
  end
  # TODO: use webmock to mock network interactions
end
