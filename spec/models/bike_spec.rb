require "spec_helper"

describe Bike do
  describe :create_from_api_url do
    it "creates a bike from an api url" do
      fixture = JSON.parse(File.read(Rails.root.join("spec/fixtures/binx_info.json")))
      bike = Bike.create_from_api_url(fixture["api_url"])
      expect(bike.bike_index_api_url).to be_present
      target = bike.bike_index_api_response
      target.delete("registration_updated_at") # Delete updated at, it gets bumped periodically
      fixture.delete("registration_updated_at") # Delete it here too, we don't care
      expect(target).to eq(fixture)
      expect(bike.bike_index_bike_id).to be_present
      expect(bike.country).to eq("United States")
      expect(bike.city).to eq("New York")
      expect(bike.state).to eq("NY")
      expect(bike.latitude).to be_present
      expect(bike.longitude).to be_present
      # expect(bike.neighborhood).to be_present # Neighborhood not in our geo specs file...
    end
  end

  describe :get_api_response do
    it "works" do
      result = Bike.get_api_response(3414)
      fixture = JSON.parse(File.read(Rails.root.join("spec/fixtures/binx_info.json")))
      result.delete("registration_updated_at") # Delete updated at, it gets bumped periodically
      fixture.delete("registration_updated_at") # Delete it here too, we don't care
      expect(result).to eq(fixture)
    end
  end

  describe :api_v1_url_from_binx_id do
    it "returns URI" do
      uri = Bike.api_v1_url_from_binx_id("3414")
      expect(uri).to eq("https://bikeindex.org/api/v1/bikes/3414")
    end
  end

  describe :binx_id_from_url do
    it "returns id" do
      id = Bike.binx_id_from_url("https://bikeindex.org/api/v1/bikes/3414")
      expect(id).to eq(3414)
    end
  end

  describe :is_api_v1 do
    it "checks for v1" do
      bike = Bike.new(bike_index_api_url: "https://bikeindex.org/api/v1/bikes/3414")
      expect(bike.is_api_v1).to be_truthy
    end
  end

  describe :twitter_accounts_in_proximity_close_accounts do
    it "returns in proximity order and always puts national in last place" do
      bike = FactoryGirl.create(:canadian_bike)
      default = FactoryGirl.create(:national_active_twitter_account)
      national_account = FactoryGirl.create(:secondary_active_twitter_account, is_national: true)
      closest = FactoryGirl.create(:secondary_active_twitter_account,
                                   latitude: 48.992195, longitude: -122.748103, country: "United States") # In Blain Washington, town right across the border
      close_accounts = bike.twitter_accounts_in_proximity
      expect(close_accounts).to eq([closest, national_account])
    end

    it "finds default national account" do
      bike = FactoryGirl.create(:canadian_bike)
      default = FactoryGirl.create(:national_active_twitter_account)
      national_account = FactoryGirl.create(:secondary_active_twitter_account, is_national: true)
      national_account.update_attribute :country, "Canada"
      expect(bike.twitter_accounts_in_proximity).to eq([national_account])
    end
  end
end
