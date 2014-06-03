require 'spec_helper'
require_relative '../../../lib/integrations/twitter_tweeter_integration'
require 'dotenv'

Dotenv.load

describe TwitterTweeterIntegration do
  before(:each) do
    TwitterTweeterIntegration.send(:public, *TwitterTweeterIntegration.private_instance_methods)

    @bike_no_media = Bike.new
    bi_response = '{"bikes":{"id":967,"serial":"absent","registration_created_at":"2013-10-15T12:50:37-05:00","registration_updated_at":"2014-03-12T19:44:06-05:00","url":"https://bikeindex.org/bikes/967","api_url":"https://bikeindex.org/api/v1/bikes/967","manufacturer_name":"Trek","manufacturer_id":47,"frame_colors":["Blue","Stickers tape or other cover-up"],"paint_description":null,"stolen":true,"name":"","year":null,"frame_model":"930","description":"Trek 930 with a rack, new trigger shifters (replaced from the standard grip shifters), new grips, bar ends. Three stickers: 1 saying \"Burritophile\", another SFBC member sticker, and a 0.00 and 0/10ths gas price sticker. ","rear_tire_narrow":true,"front_tire_narrow":true,"photo":null,"thumb":null,"title":"Trek 930 (blue and stickers tape or other cover-up)","images":[],"rear_wheel_size":{"iso_bsd":559,"name":"26in","description":"26in (Standard size)"},"front_wheel_size":{"iso_bsd":559,"name":"26in","description":"26in (Standard size)"},"handlebar_type":{"name":"Flat","slug":"flat"},"frame_material":{"name":"Steel","slug":"steel"},"front_gear_type":{"name":"3"},"rear_gear_type":{"name":"8"},"stolen_record":{"date_stolen":"2013-09-30T01:00:00-05:00","location":"San Francisco, CA, 94117","latitude":37.770506,"longitude":-122.436556,"theft_description":"Someone climbed up to my porch on the second floor and ripped it right off. ","locking_description":"","lock_defeat_description":"","police_report_number":"","police_report_department":null},"components":[]}}'
    @bike_no_media.bike_index_api_response = JSON.parse(bi_response)
    @bike_no_media.serialize_api_response

    @twitter_account = TwitterAccount.new
    @twitter_account[:consumer_key]    = ENV['CONSUMER_KEY']
    @twitter_account[:consumer_secret] = ENV['CONSUMER_SECRET']
    @twitter_account[:user_token]        = ENV['ACCESS_TOKEN']
    @twitter_account[:user_secret] = ENV['ACCESS_TOKEN_SECRET']
  end

  describe :twitter_client_start do
    it "returns a functional Twitter::REST::Client" do
      client = TwitterTweeterIntegration.new(@bike_no_media).twitter_client_start(@twitter_account)
      expect(client).to be_an_instance_of(Twitter::REST::Client)
    end
  end

  describe :build_bike_status do
    it "creates correct string without media" do
      pp TwitterTweeterIntegration.new(@bike_no_media).build_bike_status
      expect(TwitterTweeterIntegration.new(@bike_no_media).build_bike_status).to eq("STOLEN - Blue Trek 930 in Lower Haight https://bikeindex.org/bikes/967")
    end
  end

  describe :create_tweet do
    xit "posts a text only tweet properly" do
      pp @bike_no_media.bike_index_api_response[:bikes][:stolen_record][:latitude]
      pp @bike_no_media.bike_index_api_response[:bikes][:stolen_record][:longitude]
      expect(TwitterTweeterIntegration.new(@bike_no_media).create_tweet).to be_an_instance_of(Twitter::Tweet)
    end
  end
end
    
