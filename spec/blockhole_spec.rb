require_relative '../lib/blockhole'
require_relative 'spec_helper'

describe Blockhole do
  let(:redis) do
    Redis.new(host: 'localhost', port: '6379')
  end

  it 'should have a version number' do
    Blockhole::VERSION.should_not be_nil
  end

  before do
    Blockhole.configure do |b|
      b.storage = redis
    end
  end

  it 'caches things' do
    Blockhole.use_hole('pie-hole') { 'blueberry pie' }
    pie = Blockhole.use_hole('pie-hole') { 'cherry pie' }
    pie.should == 'blueberry pie'
  end
end
