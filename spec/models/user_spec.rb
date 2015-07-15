require 'spec_helper'

describe User do
  it { should belong_to :twitter_account }

  describe :twitter_credentials do 
    it "grabs and makes indifferent" do 
      user = User.new
      user.twitter_info = omniauth_twitter_fixture
      expect(user.twitter_credentials[:token]).to eq('a1b2c3d4...')
    end
  end

  describe :screenname do 
    it "Twitter screenname" do 
      user = User.new
      user.twitter_info = omniauth_twitter_fixture
      expect(user.screenname).to eq('johnqpublic')
    end
  end

  describe :find_or_create_associated_twitter_account do 
    it "sets the associated twitter account" do 
      user = User.new
      user.twitter_info = omniauth_twitter_fixture
      twitter_account = TwitterAccount.new(screen_name: 'johnqpublic')
      expect(TwitterAccount).to receive(:fuzzy_screenname_find).with('johnqpublic').
        and_return(twitter_account)
      account = user.find_or_create_associated_twitter_account
      expect(account).to eq(twitter_account)
    end

    it "creates the twitter account if one doesn't exist" do
      fixture = omniauth_twitter_fixture
      user = User.from_omniauth(fixture['uid'], fixture)
      expect(user.screenname).to eq('johnqpublic')
      expect(user.twitter_account).to be_blank
      account = user.find_or_create_associated_twitter_account
      expect(account.id).to be_present
      expect(account.consumer_key).to be_present
      expect(account.consumer_secret).to be_present
      expect(account.user_token).to be_present
      expect(account.user_secret).to be_present
      expect(account.latitude).to be_blank
    end
  end

  describe :update_twitter_info do 
    it "associates a created twitter account" do 
      fixture = omniauth_twitter_fixture
      fixture['info']['location'] = ' '
      user = User.from_omniauth(fixture['uid'], fixture)
      expect(user.screenname).to eq('johnqpublic')
      expect(user.twitter_account).to be_blank
      user.update_twitter_info
      expect(user.twitter_account_id).to be_present
      expect(user.twitter_account.consumer_key).to be_present
      expect(user.twitter_account.consumer_secret).to be_present
      expect(user.twitter_account.user_token).to be_present
      expect(user.twitter_account.user_secret).to be_present
      expect(user.twitter_account.latitude).to be_blank
      expect(user.twitter_account.address).to be_blank
    end
  end
  
end