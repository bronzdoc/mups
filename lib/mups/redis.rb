require "redis"

module Mups
  class Redis
    attr_reader :conn

    def initialize(redis_url)
      @conn = ::Redis.new(url: URI.parse(redis_url))
    end

    def method_missing(method, *args, &block)
      conn.send(method, *args, &block)
    end
  end
end
