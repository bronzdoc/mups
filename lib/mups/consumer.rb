#require "redis"
require "json"
require "thread"
require "socket"
require "logger"
require "http"

module Mups
  class Consumer
    attr_reader :queue, :stream_uri

    def initialize(redis)
      @redis = redis

      # Try to start the stream with the las mtime enqueued
      @stream_uri = if @redis.llen("mups:mtime") > 0
               mtime = @redis.lpop("mups:mtime")
               URI("http://stream.meetup.com/2/open_events?since_mtime=#{mtime}")
             else
               URI("http://stream.meetup.com/2/open_events")
             end
      @queue = Queue.new
      @logger = Logger.new(STDOUT)
    end

    def start
      Thread.abort_on_exception = true

      read = Thread.new(queue) do |queue|
        body = HTTP.get(@stream_uri).body

        buffer = ""
        body.each do |chunk|
          buffer += chunk
          # Enqueue event data just if we have a complete chunk
          if buffer.chars.last == "\n"
            queue.push(buffer)
            buffer = ""
          end
        end
        # Push nil to signify there's no more data in the queue
        queue.push nil
      end

      consume = Thread.new(queue) do |queue|
        while queue_data = queue.pop
          break if queue_data.is_a? NilClass

          begin
            title = JSON.parse(queue_data)["name"]
            count = @redis.lpush("mups:titles", title)

            mtime = JSON.parse(queue_data)["mtime"]
            @redis.lpush("mups:mtime", mtime)

            @logger.info("REDIS -> list count #{count}")
          rescue JSON::ParserError => e
            @logger.error(e.message)
          end
        end
      end

      [read, consume].map(&:join)
    end
  end
end
