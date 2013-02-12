require 'blockhole'
require_relative 'spec_helper'

describe Blockhole do
  it 'should have a version number' do
    Blockhole::VERSION.should_not be_nil
  end

  it 'should cache things' do
    Blockhole.use_hole('pie-hole') { 'blueberry pie' }
    pie = Blockhole.use_hole('pie-hole') { 'cherry pie' }
    pie.should == 'blueberry pie'
  end

  it 'should support blocks that return hash objects' do
    Blockhole.use_hole('pie-hole') do
      { 'name' => 'blueberry pie'}
    end

    pie = Blockhole.get('pie-hole')
    pie.should be_kind_of Hash

    pie['name'].should == 'blueberry pie'
  end

  it 'should support blocks that return array objects' do
    Blockhole.use_hole('pie-hole') do
      ['blueberry', 'cherry']
    end

    pies = Blockhole.get('pie-hole')
    pies.should be_kind_of Array
    pies[0].should == 'blueberry'
  end

  context 'with an optional lifespan' do
    it 'expires values' do
      Blockhole.use_hole('pie-hole', 10) { 'blueberry pie' }
      sleep(50/1000) #50 milliseconds
      pie = Blockhole.use_hole('pie-hole') { 'cherry pie' }
      pie.should == 'cherry pie'
    end

    it 'requires that lifespan be 1 or greater' do
      lambda do
        Blockhole.use_hole('pie-hole', -1) { 'blueberry pie' }
      end.should raise_error ArgumentError
    end
  end

  describe 'get' do
    it 'gets the values back out again' do
      Blockhole.use_hole('pie-hole') { 'blueberry pie' }
      Blockhole.get('pie-hole').should == 'blueberry pie'
    end
  end

  describe 'collapse' do
    it 'should bust the cache' do
      Blockhole.use_hole('pie-hole') { 'blueberry' }
      Blockhole.collapse('pie-hole')
      Blockhole.use_hole('pie-hole') { 'cherry' }
      Blockhole.get('pie-hole').should == 'cherry'
    end
  end
end
