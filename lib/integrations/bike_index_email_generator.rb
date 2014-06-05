class BikeIndexEmailGenerator
  require 'httparty'

  def create_email(tweet)
    rt_screen_names = []
    if tweet.retweets.present?
      tweet.retweets.each { |retweet| rt_screen_names << retweet.twitter_account.screen_name }
    else
      rt_screen_names = nil
    end

    email = {}
    email[:bike_id] = tweet.bike.bike_index_api_response[:id]
    email[:title] = "We tweeted about your stolen bike!"
    email[:body] = %Q^We're telling everyone about it with <a href='https://twitter.com/twitter/status/#{tweet.twitter_tweet_id}'>this tweet</a>. Go ahead and retweet it! #{rt_screen_names ? "We already did from #{rt_screen_names.to_sentence}." : nil }^
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
