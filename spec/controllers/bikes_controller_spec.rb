require 'spec_helper'

describe BikesController do
  describe "POST #create" do
    context "without correct parameters" do
      it "should fail without :api_url" do
        post(:create, {})
        expect(response.code).to eq('401')
      end
      it "should fail without :key" do
        post(:create, { api_url: "https://bikeindex.org/api/v1/bikes/3414" })
        expect(response.code).to eq('401')
      end
    end

    context "with an :api_url" do
      it "should return success" do
        allow_any_instance_of(BikesController).to receive(:verify_key)
        expect_any_instance_of(BikeIndexEmailGenerator).to receive(:send_email_hash)
        expect_any_instance_of(TwitterTweeterIntegration).to receive(:create_tweet)
        options = { api_url: "https://bikeindex.org/api/v1/bikes/3414" }
        post :create, options, format: :json
        expect(response).to be_success
        expect(JSON.parse(response.body)['success']).to be_truthy
      end

      it "posts a media tweet and retweets properly" do
        unless ENV['CODECLIMATE_REPO_TOKEN'].present? # We don't want to test this on travis, it creates a tweet every time
          # Test everything! (Record it in VCR though)
          # This will send an email and tweet to the secondary active twitter if cassette is missing
          # 
          VCR.use_cassette('bikes_controller_create') do
            twitter_account = FactoryGirl.create(:secondary_active_twitter_account, default: true)
            options = { 
              api_url: "https://bikeindex.org/api/v1/bikes/51540",
              key: ENV['INCOMING_REQUEST_KEY']
            }
            post :create, options, format: :json
            expect(response).to be_success
            expect(JSON.parse(response.body)['success']).to be_truthy
          end
        end
      end
    end
  end  
end
