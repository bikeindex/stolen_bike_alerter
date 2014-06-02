require 'spec_helper'

describe TwitterAccount do
  it { should have_many :tweets }

  it "should geocode madison square gardens correctly without hitting API" do
    twitter_account = TwitterAccount.new
    # madison square gardens is set up in a test fixture and geocoder testing
    # is following http://davidtuite.com/posts/how-to-test-the-ruby-geocoder-gem
    twitter_account.address = "4 Penn Plaza, New York, NY 10001, USA"
    twitter_account.geocode
    
    expect(twitter_account.latitude).to eq(40.7536276)
    expect(twitter_account.longitude).to eq(-73.9902364)
  end
  
end
