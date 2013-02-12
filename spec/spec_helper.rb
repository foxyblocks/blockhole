$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'blockhole'
require 'redis'

RSpec.configure do |config|
  config.before(:all) do
    $redis = Redis.new(:host => 'localhost', :port => 6379)
    Blockhole.configure do |b|
      b.storage = $redis
    end
  end
  config.before(:each) do
    $redis.flushdb
  end
end
