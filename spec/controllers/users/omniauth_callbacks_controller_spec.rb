require 'spec_helper'

describe Users::OmniauthCallbacksController do

  describe '#twitter' do    
    it "creates a user when there is no user" do
      set_omniauth_twitter
      expect_any_instance_of(TwitterAccount).to receive(:get_account_info).and_return({})
      expect {
        post :twitter
      }.to change(User, :count).by(1)
      expect(response.code).to eq('302')
      user = User.last
      expect(user.twitter_uid).to eq(omniauth_twitter_fixture['uid'])
      expect(user.twitter_info).to be_present
    end

    it "updates the user's token if the token needs be updated" do
      og_omni = omniauth_twitter_fixture
      og_omni['credentials']['token'] = "fake"
      og_omni['credentials']['refresh_token'] = "other_fake"
      user = User.from_omniauth(og_omni['uid'], og_omni)
      expect(user.twitter_info['credentials']['token']).to eq('fake')
      expect(user.twitter_credentials[:refresh_token]).to eq('other_fake')
      set_omniauth_twitter
      expect_any_instance_of(TwitterAccount).to receive(:get_account_info).and_return({})
      post :twitter
      expect(response.code).to eq('302')
      user.reload
      expect(user.twitter_credentials['token']).to eq(omniauth_twitter_fixture['credentials']['token'])
      expect(user.twitter_credentials['refresh_token']).to_not eq('other_fake')
    end

  end
  
end
