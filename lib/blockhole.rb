require "blockhole/version"
require 'redis'

module Blockhole
  class << self
    attr_accessor :storage

    def configure
      yield self
      self
    end

    def use_hole(hole_name, lifespan = nil, &block)
      if lifespan and lifespan < 1
        raise ArgumentError,
          "lifespan (if provided) must be >= 1, got #{lifespan}"
      end

      unless value = storage.get(hole_name)
        value = block.call(hole_name)
        storage.set(hole_name, value)
        storage.expire(hole_name, lifespan / 1000) if lifespan
      end

      value
    end

    def get(name)
      storage.get(name)
    end
  end
end
