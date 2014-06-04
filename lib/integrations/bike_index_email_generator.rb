class BikeIndexEmailGenerator
  require 'httparty'
  require 'dotenv'
  Dotenv.load

  def create_email(tweet)
    email = {}
    email[:bike_id] = tweet.bike.bike_index_api_response[:bikes][:id]
    email[:title] = "We tweeted about your stolen bike!"
    email[:body] = """We're telling everyone about it with <a href='https://twitter.com/twitter/status/#{tweet.twitter_tweet_id}'>this tweet</a>. Go ahead and retweet it!""" 
    email[:organization_slug] = ENV['EMAIL_ORGANIZATION_SLUG']
    email[:access_token] = ENV['EMAIL_ACCESS_TOKEN']
    return email
    # #{tweet.has_retweets ? "We already did from 
  end

  def send_email(tweet)
    email = create_email(tweet)
    params = { body: email.to_json, headers: { 'Content-Type' => 'application/json' } }
    HTTParty.post('https://bikeindex.org/api/v1/bikes/send_notification_email', params)
  end
end
