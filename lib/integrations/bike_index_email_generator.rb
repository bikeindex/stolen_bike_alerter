class BikeIndexEmailGenerator
  require 'httparty'

  def send_email_hash(tweet)
    tweet.create_bike_index_post_hash
    tweet.save
    params = { 
      body: {
        access_token: ENV['BIKE_INDEX_NOTIFICATIONS_API_KEY'],
        notification_hash: tweet.bike_index_post_hash
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    }
    HTTParty.post('https://bikeindex.org/api/v1/notifications', params)
  end
end
