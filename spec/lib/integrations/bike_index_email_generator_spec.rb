require 'spec_helper'

describe 'BikeIndexEmailGenerator' do
  describe :create_email do
    it "doesn't mention retweets when there aren't any" do
      VCR.use_cassette('bike_index_email_generator') do
        twitter_account = FactoryGirl.create(:secondary_active_twitter_account)
        bike = FactoryGirl.create(:bike_with_binx)
        bike.save
        tweet = Tweet.new(twitter_tweet_id: 69,
          tweet_string: 'STOLEN - something special',
          bike_id: bike.id,
          twitter_account_id: twitter_account.id
        )
        result = BikeIndexEmailGenerator.new.send_email_hash(tweet)
        expect(result['success']).to be_truthy
      end
    end
  end
end