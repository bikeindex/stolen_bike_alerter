class BikeIndexEmailGenerator
  require 'net/http'
  require 'uri'

  def create_email(tweet)
    email = {}
    email[:id] = Bike.find(tweet.bike_id).bike_index_api_response[:bikes][:id]
    email[:title] = "We tweeted about your stolen bike!"
    email[:body] = """We're telling everyone about it with <a href='https://twitter.com/twitter/status/#{tweet.twitter_tweet_id}'>this tweet</a>. Go ahead and retweet it!""" 

    # #{tweet.has_retweets ? "We already did from 
  end

  def send_email(tweet)
    email = create_email(tweet)
    uri = URI.parse("https://bikeindex.org/api/v1/bikes/send_notification_email")
    response = Net::HTTP.post_form(uri, email)
  end
end
