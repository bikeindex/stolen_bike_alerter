FactoryGirl.define do
  sequence :unique_name do |n|
    "Sweet name #{n}"
  end

  factory :user do 
    twitter_info omniauth_twitter_fixture
  end

  factory :twitter_account do 
    address "4 Penn Plaza, New York, NY 10001, USA"
    latitude 40.750354
    longitude -73.9933710
    factory :active_twitter_account do 
      screen_name ENV['TEST_SCREEN_NAME']
      consumer_key ENV['CONSUMER_KEY']
      consumer_secret ENV['CONSUMER_SECRET']
      user_token ENV['ACCESS_TOKEN']
      user_secret ENV['ACCESS_TOKEN_SECRET']
      twitter_account_info JSON.parse(File.read(Rails.root.join("spec/fixtures/account_info.json")))
      is_active true
      factory :national_active_twitter_account do 
        is_national true
      end
    end
  end

  factory :bike do 
    factory :bike_with_binx do 
      bike_index_bike_id 3414
      bike_index_api_url "https://bikeindex.org/api/v1/bikes/3414"
      bike_index_api_response JSON.parse(File.read(Rails.root.join("spec/fixtures/binx_info.json")))
    end
    factory :canadian_bike do
      bike_index_bike_id 51540
      bike_index_api_url "https://bikeindex.org/api/v1/bikes/51540"
      bike_index_api_response JSON.parse(File.read(Rails.root.join("spec/fixtures/binx_canadian_info.json")))
    end
  end
  
end
