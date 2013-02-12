require "blockhole/version"
require 'redis'

module Blockhole
  class << self
    attr_accessor :storage

    def use_hole(hole_name, &block)
      unless value = storage.get(hole_name)
        value = block.call(hole_name)
        storage.set(hole_name, value)
      end
      value
    end

    def configure
      yield self
      self
    end
  end
end
