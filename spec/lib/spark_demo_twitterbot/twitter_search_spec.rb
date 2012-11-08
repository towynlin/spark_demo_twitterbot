require 'spark_demo_twitterbot/twitter_search'

describe SparkDemoTwitterbot::TwitterSearch do
  it 'raises an ArgumentError when initialized with no arguments' do
    expect { SparkDemoTwitterbot::TwitterSearch.new }.to raise_error(ArgumentError)
  end
  # TODO: use webmock to mock network interactions
end
