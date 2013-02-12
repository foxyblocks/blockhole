require 'blockhole'
require_relative 'spec_helper'

describe Blockhole do
  it 'should have a version number' do
    Blockhole::VERSION.should_not be_nil
  end

  it 'caches things' do
    Blockhole.use_hole('pie-hole') { 'blueberry pie' }
    pie = Blockhole.use_hole('pie-hole') { 'cherry pie' }
    pie.should == 'blueberry pie'
  end

  context 'with an expiration' do
    it 'expires values' do
      Blockhole.use_hole('pie-hole', 10) { 'blueberry pie' }
      sleep(50/1000) #50 milliseconds
      pie = Blockhole.use_hole('pie-hole') { 'cherry pie' }
      pie.should == 'cherry pie'
    end

    it 'requires that expiration be greater than 1' do
      lambda do
        Blockhole.use_hole('pie-hole', -1) { 'blueberry pie' }
      end.should raise_error ArgumentError
    end
  end

  describe 'get' do
    it 'gets the values back out' do
      Blockhole.use_hole('pie-hole') { 'blueberry pie' }
      Blockhole.get('pie-hole').should == 'blueberry pie'
    end
  end
end
