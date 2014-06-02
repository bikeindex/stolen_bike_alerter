require 'spec_helper'

describe BikesController do
  describe "POST #create" do
    context "without correct parameters" do
      it "should fail without :api_url" do
        expect{ post(:create, {}) }.to raise_error(ActionController::ParameterMissing)
      end
      it "should fail with incorrect parameters" do
        expect{ post(:create, {name: "seth"}) }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context "with an :api_url" do
      it "should return success" do
        post(:create, {api_url: "https://bikeindex.org/api/v1/bikes/3414"})
        expect(response).to be_success
      end
      it "should create a tweet on the appropriate twitter" do
        
      end
    end
  end
end
