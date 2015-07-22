FactoryGirl.define do
  sequence :unique_name do |n|
    "Sweet name #{n}"
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
      twitter_account_info JSON.parse(File.read(Rails.root.join("spec/fixtures/account_info.json"))).with_indifferent_access
      is_active true
      factory :national_active_twitter_account do 
        is_national true
      end
    end
    factory :secondary_active_twitter_account do 
      no_geocode true
      screen_name ENV['SECOND_TEST_SCREEN_NAME']
      consumer_key ENV['OMNIAUTH_CONSUMER_KEY']
      consumer_secret ENV['OMNIAUTH_CONSUMER_SECRET']
      user_token ENV['SECOND_ACCESS_TOKEN']
      user_secret ENV['SECOND_ACCESS_TOKEN_SECRET']
      country "Canada"
      city "Vancouver"
      state "BC"
      latitude 49.253992
      longitude -123.241084
      twitter_account_info JSON.parse(File.read(Rails.root.join("spec/fixtures/secondary_account_info.json"))).with_indifferent_access
      is_active true
    end
  end

  factory :bike do 
    factory :bike_with_binx do 
      bike_index_bike_id 3414
      bike_index_api_url "https://bikeindex.org/api/v1/bikes/3414"
      bike_index_api_response JSON.parse(File.read(Rails.root.join("spec/fixtures/binx_info.json"))).with_indifferent_access
      country "United States"
      city "New York"
      state "NY"
      latitude 41.9218917
      longitude -87.6989887
    end
    factory :canadian_bike do
      no_geocode true
      bike_index_bike_id 51540
      bike_index_api_url "https://bikeindex.org/api/v1/bikes/51540"
      bike_index_api_response JSON.parse(File.read(Rails.root.join("spec/fixtures/binx_canadian_info.json"))).with_indifferent_access
      country "Canada"
      city "Vancouver"
      state "BC"
      latitude 49.2793917
      longitude -123.1168054
    end
    factory :bike_no_media do
      no_geocode true
      bike_index_bike_id 967
      bike_index_api_url "https://bikeindex.org/api/v1/bikes/967"
      bike_index_api_response JSON.parse(File.read(Rails.root.join("spec/fixtures/binx_no_media_info.json"))).with_indifferent_access
      country "United States"
      city "San Francisco"
      neighborhood "Lower Haight"
      state "CA"
      latitude 37.770506
      longitude -122.436556
    end
  end

  factory :user do 
    twitter_info JSON.parse(File.read(Rails.root.join("spec/fixtures/omniauth_twitter_response.json")))
    twitter_account
  end
  
  factory :user_with_active_twitter_account, class: User do 
    twitter_info JSON.parse(File.read(Rails.root.join("spec/fixtures/omniauth_twitter_response.json")))
    association :twitter_account, factory: :national_active_twitter_account
  end
  
end
