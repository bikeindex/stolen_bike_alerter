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
        expect_any_instance_of(TwitterTweeterIntegration).to receive(:create_tweet)
        expect_any_instance_of(BikeIndexEmailGenerator).to receive(:send_email_hash)
        options = { api_url: "https://bikeindex.org/api/v1/bikes/3414" }
        post :create, options, format: :json
        expect(response).to be_success
      end

      xit "should create a tweet on the appropriate twitter" do
      end
    end
  end
  
  describe "bike_index_reponse" do 
    it "should get a bike index response" do 
      bike_index_api_url = 'https://bikeindex.org/api/v1/bikes/3414'
      bike_response = BikesController.new.bike_index_response(bike_index_api_url)
      expect(bike_response['serial']).to eq('stolen_serial_number')
    end
  end
end



