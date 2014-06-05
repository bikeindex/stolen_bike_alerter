require 'spec_helper'

describe BikeIndexEmailGenerator do
  before(:each) do
    @tweet = Tweet.new do |t|
      t.twitter_account_id = 1
      # note: 23 has retweets, 24 does not.
      # t.bike_id = 23 
      t.id = 1
    end
  end

  describe :create_email do
    it "doesn't mention retweets when there aren't any" do
      @tweet.bike_id = 24
      email = BikeIndexEmailGenerator.new.create_email(@tweet)
      expect(email[:body]).not_to match(/already/)
    end

    it "creates the proper sentence when there are retweets" do
      @tweet.bike_id = 23
    end
  end
end
