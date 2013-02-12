require "blockhole/version"
require 'redis'
require 'multi_json'

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
        storage.set(hole_name, encode(value))
        storage.expire(hole_name, lifespan / 1000) if lifespan
      end

      value
    end

    def get(name)
      value = storage.get(name)
      begin
        return MultiJson.load value
      rescue MultiJson::DecodeError
        return value
      end
    end

  private

    def encode(value)
      return value if value.kind_of? String
      MultiJson.dump value
    end
  end
end
