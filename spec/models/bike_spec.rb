require 'spec_helper'

describe Bike do

  it { should have_one :tweet }
  it { should have_many :retweets }
  it { should validate_presence_of :bike_index_api_url }
  it { should validate_presence_of :bike_index_api_response }
  it { should serialize :bike_index_api_response }

  # describe :serialize do 
  #   xit "should make a hash with indifferent access out of an API response" do
  #     bike = FactoryGirl.build(:bike_with_binx)
  #     # bi_response = 
  #     # bike.bike_index_api_response = JSON.parse(bi_response)['bikes']
  #     bike.serialize_api_response
  #     bike.latitude = bike.bike_index_api_response[:stolen_record][:latitude]
  #     bike.longitude = bike.bike_index_api_response[:stolen_record][:longitude]
  #     expect(bike.bike_index_api_response[:id]).to eq(3414)
  #     expect(bike.bike_index_bike_id).to eq(3414)
  #   end
  # end

  describe :create_from_api_url do 
    it "creates a bike from an api url" do 
      fixture = JSON.parse(File.read(Rails.root.join("spec/fixtures/binx_info.json")))
      bike = Bike.create_from_api_url(fixture['api_url'])
      expect(bike.bike_index_api_url).to be_present
      expect(bike.bike_index_api_response).to eq(fixture)
      expect(bike.bike_index_bike_id).to be_present
      pp bike.city
      pp bike.state
      pp bike.latitude
      pp bike.longitude
      expect(bike.city).to be_present
      expect(bike.state).to be_present
      expect(bike.latitude).to be_present
      expect(bike.longitude).to be_present
      # expect(bike.neighborhood).to be_present # Not in our geo specs file...
    end
  end

  describe :api_v1_url_from_binx_id do 
    it "returns URI" do
      uri = Bike.api_v1_url_from_binx_id("3414")
      expect(uri).to eq(URI.parse("https://bikeindex.org/api/v1/bikes/3414"))
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

  
end
