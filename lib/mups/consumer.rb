require "json"
require "thread"
require "socket"
require "logger"
require "pry"

module Mups
  class Consumer
    attr_reader :queue

    def initialize
      uri = URI("http://stream.meetup.com")
      @queue = Queue.new
      @socket = TCPSocket.new(uri.host, uri.port)
      @logger = Logger.new(STDOUT)
    end

    def start
      read = Thread.new(queue) do |queue|
        @socket.puts "GET /2/open_events HTTP/1.1\r\n"
        @socket.puts "Host: stream.meetup.com"
        @socket.puts "\r\n"
        while data = @socket.gets.strip
          if data.chars.first == "{"
            parsed_data = JSON.parse(data)
            queue.push(parsed_data)
          end
        end
        @socket.close
        queue.push NilClass
      end

      consume = Thread.new(queue) do |queue|
        while queue_data = queue.pop
          break if queue_data.is_a? NilClass
          parsed_data = JSON.parse(queue_data)
          @logger.info("Queuing -> Title: #{queue_data["name"]}")
        end
      end

      [read, consume].map(&:join)
    end
  end
end
