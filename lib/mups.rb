require "mups/version"
require "mups/redis"
require "mups/consumer"
require "logger"

module Mups
  def self.start(redis_url=nil)
    if redis_url.nil?
      help
      exit
    end

    logger = Logger.new(STDOUT)
    begin
      redis = Mups::Redis.new(redis_url)
      Mups::Consumer.new(redis).start
    rescue ::Redis::CannotConnectError
      logger.info("Could not connect to #{redis_url}")
    end
  end

  def self.help
    puts <<-HELP
    Mups will connect to the Meetup.com event stream and store event titles in redis
    REDIS list name: mups:titles

    Usage:
     gem -h/--help
     gem url

    Examples:
     mups redis://user@server:6379
    HELP

  end
end
