require "mups/consumer"
require "mups/redis"

RSpec.describe Mups::Consumer do
  describe "#new" do
    describe "mtime available in redis" do
      before do
        @mtime = "1294435118533"
        @redis = Redis.new
      end

      it "should build url with the mtime variable" do
        @redis.lpush("mups:mtime", @mtime)
        mups = Mups::Consumer.new(@redis)
        expect(mups.stream_uri.to_s).to match(@mtime)
      end
    end
  end
end
