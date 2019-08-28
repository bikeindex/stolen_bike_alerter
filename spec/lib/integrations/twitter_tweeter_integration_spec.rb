require "spec_helper"

describe "TwitterTweeterIntegration" do
  describe :twitter_client_start do
    it "returns a functional Twitter::REST::Client" do
      @bike_no_media = FactoryGirl.build(:bike_with_binx)
      @twitter_account = FactoryGirl.build(:active_twitter_account)
      client = TwitterTweeterIntegration.new(@bike_no_media).twitter_client_start(@twitter_account)
      expect(client).to be_an_instance_of(Twitter::REST::Client)
    end
  end

  describe :build_bike_status do
    context "stolen bike" do
      before(:each) do
        @bike_no_media = FactoryGirl.build(:bike_no_media)
        @default_account = FactoryGirl.build(:secondary_active_twitter_account, default: true)
        @twitter_account = FactoryGirl.build(:active_twitter_account)
      end

      it "creates correct string without media" do
        @bike_no_media.bike_index_api_response["frame_model"] = "930"
        tti = TwitterTweeterIntegration.new(@bike_no_media)
        tti.instance_variable_set(:@close_twitters, [@twitter_account])
        # pp tti
        expect(tti.build_bike_status).to eq("STOLEN - Blue Trek 930 in Lower Haight https://bikeindex.org/bikes/967")
      end

      it "creates correct string with media" do
        @bike_no_media.bike_index_api_response["frame_model"] = "930"
        tti = TwitterTweeterIntegration.new(@bike_no_media)
        tti.instance_variable_set(:@close_twitters, [@twitter_account])
        expect(tti.build_bike_status).to eq("STOLEN - Blue Trek 930 in Lower Haight https://bikeindex.org/bikes/967")
      end

      it "creates correct string with append block" do
        @bike_no_media.bike_index_api_response["frame_model"] = "930"
        @twitter_account.append_block = "#bikeParty"
        tti = TwitterTweeterIntegration.new(@bike_no_media)
        tti.instance_variable_set(:@close_twitters, [@twitter_account])
        status = tti.build_bike_status
        expect(status).to eq("STOLEN - Blue Trek 930 in Lower Haight https://bikeindex.org/bikes/967 #bikeParty")
        @twitter_account.append_block = nil
      end

      it "creates correct string without append block if string is too long" do
        @twitter_account.append_block = "#bikeParty"
        @bike_no_media.bike_index_api_response["frame_model"] = "Large and sweet MTB, a much longer frame model"
        tti = TwitterTweeterIntegration.new(@bike_no_media)
        tti.instance_variable_set(:@close_twitters, [@twitter_account])
        status = tti.build_bike_status
        expect(status).to eq("STOLEN - Blue Trek Large and sweet MTB, a much longer frame model in Lower Haight https://bikeindex.org/bikes/967")
        @twitter_account.append_block = nil
      end
    end

    context "recovered bike" do
      it "creates correct string without append block if string is too long" do
        @bike_no_media = FactoryGirl.build(:bike_recovered)
        @default_account = FactoryGirl.build(:secondary_active_twitter_account, default: true)
        @twitter_account = FactoryGirl.build(:active_twitter_account)
        @twitter_account.append_block = "#bikeParty"
        tti = TwitterTweeterIntegration.new(@bike_no_media)
        tti.instance_variable_set(:@close_twitters, [@twitter_account])
        status = tti.build_bike_status
        expect(status).to eq("FOUND - Green Novara Torero 29\" in Lower Haight https://bikeindex.org/bikes/56990 #bikeParty")
        @twitter_account.append_block = nil
      end
    end
  end

  describe :create_tweet do
    it "posts a text only tweet properly" do
      VCR.use_cassette("twitter_tweeter_integration_create_tweet") do
        bike_no_media = FactoryGirl.build(:bike_no_media)
        twitter_account = FactoryGirl.build(:active_twitter_account, id: 99)
        integration = TwitterTweeterIntegration.new(bike_no_media)
        expect(bike_no_media).to receive(:twitter_accounts_in_proximity).and_return([twitter_account])
        integration.create_tweet
        expect(integration.retweets.first).to be_an_instance_of(Twitter::Tweet)
      end
    end
    it "creates a media tweet with retweets" do
      VCR.use_cassette("twitter_tweeter_integration_create_retweet") do
        bike_no_media = FactoryGirl.create(:bike_with_binx)
        twitter_account = FactoryGirl.build(:active_twitter_account, id: 99)
        secondary_twitter_account = FactoryGirl.build(:secondary_active_twitter_account, id: 9)
        integration = TwitterTweeterIntegration.new(bike_no_media)
        close_twitters = [twitter_account, secondary_twitter_account]
        expect(bike_no_media).to receive(:twitter_accounts_in_proximity).and_return([twitter_account, secondary_twitter_account])
        expect {
          integration.create_tweet
        }.to change { Retweet.count }.by(1)
        expect(integration.retweets.first).to be_an_instance_of(Twitter::Tweet)
      end
    end
  end
end
