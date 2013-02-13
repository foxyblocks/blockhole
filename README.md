# Blockhole (WIP)

Have an expensive block that you need to cache? Maybe an http response from an
expensive third party service? It currently only supports redis for storage,
but more options are forthcoming.

Inspired heavily from the interface of [VCR](https://github.com/vcr/vcr)
Blockhole will suck up the response from the block so it only runs once.

    Blockhole.use_hole('pie-hole') do
      # some expensive operation
    end


## Installation

Add this line to your application's Gemfile:

    gem 'blockhole'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blockhole

## Usage


### Configuration

The first step is to configure Blockhole to use your redis connection.
Instructions on setting up a redis connection can be found in the [redis-rb
docs](https://github.com/redis/redis-rb).

    Blockhole.configure do |b|
      b.storage = Redis.new(:host => 'localhost', :port => 6379)
    end


### Basic usage

Next record a block by passing the name of the redis key you would like to use.

    my_pie = Blockhole.use_hole('pie-hole') do
      # some expensive operation to get pie
      # probably cherry
    end

Blockhole will check redis cache for that key and return that value if it
exists (this is called a *cache hit*). If it doesn't find anything it will run
the block, store it's return value in the cache and return it to you.

You can also explicitly get the value back out without passing a block using
a get call.

    my_pie = Blockhole.get('pie-hole') # still cherry

### What can be stored

Anything that can be fed into `MultiJson.dump` will work.

### Expiration

You can pass an optional expiration value (in seconds). The key will
automatically be deleted after that amount of time has passed.

    lifespan = 3600 # 1 hour

    my_pie = Blockhole.use_hole('pie-hole', lifespan) do
      # some expensive operation to get pie
    end

    # an hour passes

    my_pie = Blockhole.use_hole('pie-hole', lifespan) do
      # Now it's blueberry!
    end

Note that this command will refresh the expiration each time it is called.

### Busting the cache

If you'd had enough with the existing data you can collapse the hole and clear
the cache. This will result in the key being deleted from redis.

    Blockhole.collapse('pie-hole')


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
