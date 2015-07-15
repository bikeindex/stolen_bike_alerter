require 'spec_helper'

describe TwitterAccount do
  it { should have_many :tweets }
  it { should have_one  :user }
  it { should serialize :twitter_account_info }

  it "should geocode madison square gardens correctly without hitting API" do
    twitter_account = TwitterAccount.new
    # madison square gardens is set up in a test fixture and geocoder testing
    # is following http://davidtuite.com/posts/how-to-test-the-ruby-geocoder-gem
    twitter_account.address = "4 Penn Plaza, New York, NY 10001, USA"
    twitter_account.geocode
    
    expect(twitter_account.latitude).to eq(40.7536276)
    expect(twitter_account.longitude).to eq(-73.9902364)
  end

  describe :twitter_link do 
    it "should create the correct twitter link" do 
      twitter_account = TwitterAccount.new(screen_name: 'stolenbikesindy')
      link = twitter_account.twitter_link
      expect(link).to match("<a href='https://twitter.com/stolenbikesindy'>@stolenbikesindy</a>")
    end
  end
  
  describe :get_account_info do 
    it "should get the twitter account info" do 
      twitter_account = TwitterAccount.new(screen_name: ENV['TEST_SCREEN_NAME'],
        consumer_key: ENV['CONSUMER_KEY'],
        consumer_secret: ENV['CONSUMER_SECRET'],
        user_token: ENV['ACCESS_TOKEN'], 
        user_secret: ENV['ACCESS_TOKEN_SECRET'])
      account_hash = twitter_account.get_account_info
      # pp account_hash
      expect(twitter_account.twitter_account_info[:name]).to be_present
      expect(twitter_account.twitter_account_info[:profile_image_url_https]).to be_present
    end
  end
end
