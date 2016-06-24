require "mups/version"
require "mups/consumer"

module Mups
  def self.start
    consumer = Mups::Consumer.new
    consumer.start
  end
end
