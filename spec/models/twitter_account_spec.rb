require 'spec_helper'

describe TwitterAccount do
  it { should have_many :tweets }
  it { should have_one  :user }
  it { should serialize :twitter_account_info }

  describe 'geocoding' do 
    it "geocodes madison square gardens correctly without hitting API" do
      twitter_account = TwitterAccount.new
      # madison square gardens is set up in a test fixture and geocoder testing
      # is following http://davidtuite.com/posts/how-to-test-the-ruby-geocoder-gem
      twitter_account.address = "4 Penn Plaza, New York, NY 10001, USA"
      twitter_account.geocode
      expect(twitter_account.latitude).to eq(40.750354)
      expect(twitter_account.longitude).to eq(-73.9933710)
    end
  end

  describe :twitter_link do 
    it "creates the correct twitter link" do 
      twitter_account = TwitterAccount.new(screen_name: 'stolenbikesindy')
      link = twitter_account.twitter_link
      expect(link).to match("<a href='https://twitter.com/stolenbikesindy'>@stolenbikesindy</a>")
    end
  end
  
  describe :get_account_info do
    it "gets the twitter account info" do 
      twitter_account = FactoryGirl.create(:active_twitter_account)
      account_hash = twitter_account.get_account_info
      expect(account_hash[:name]).to be_present
      expect(account_hash[:profile_image_url_https]).to be_present
    end
  end

  describe :set_account_info do
    it "sets the account info from get_account_info" do
      twitter_account = TwitterAccount.new
      expect(twitter_account).to receive(:get_account_info).exactly(1).times.and_return({stuff: 'foo'})
      twitter_account.set_account_info
      expect(twitter_account.twitter_account_info).to eq({stuff: 'foo'})
    end

    it "does nothing if account info is present" do 
      twitter_account = TwitterAccount.new(twitter_account_info: {stuff: 'foo'})
      expect(twitter_account).to receive(:get_account_info).exactly(0).times
      twitter_account.set_account_info
      expect(twitter_account.twitter_account_info).to eq({stuff: 'foo'})
    end
    it "has a before_save filter" do 
      TwitterAccount._save_callbacks.select { |cb| cb.kind.eql?(:before) }.map(&:raw_filter).include?(:set_account_info).should == true
    end
  end

  describe :default_account do 
    it 'returns first national account' do 
      national_account = FactoryGirl.create(:national_active_twitter_account)
      FactoryGirl.create(:national_active_twitter_account)
      TwitterAccount.default_account.should eq(national_account)
    end
  end


  describe :close_accounts do 
    it "finds close accounts" do 

    end

    it "returns default if bike is in a country we don't have an account for" do 
      bike = FactoryGirl.create(:canadian_bike)
      pp bike.city
      pp bike.state
      pp bike.neighborhood
      pp bike.latitude
      pp bike.longitude
      national_account = FactoryGirl.create(:national_active_twitter_account)
      TwitterAccount.close_accounts(bike)
    end
  end
end
