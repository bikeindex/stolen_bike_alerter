class Tweet < ActiveRecord::Base
  # Attributes  twitter_account_id, twitter_tweet_id, bike_id, tweet_string
  #             bike_index_post_hash

  belongs_to :twitter_account
  belongs_to :bike
  has_many :retweets
  has_one :base_emails
  serialize :bike_index_post_hash

  validates_presence_of :twitter_account_id
  validates_presence_of :bike_id

  def tweet_url
    "https://twitter.com/#{twitter_account.screen_name}/status/#{twitter_tweet_id}"
  end

  def create_bike_index_post_hash
    p_hash = {
      notification_type: 'stolen_twitter_alerter',
      bike_id: bike.reload.bike_index_bike_id,
      tweet_id: twitter_tweet_id,
      tweet_string: tweet_string,
      tweet_account_screen_name: twitter_account.screen_name,
      tweet_account_name: twitter_account.account_info_name,
      tweet_account_image: twitter_account.account_info_image,
      retweet_screennames: []
    }
    unless twitter_account.is_national
      p_hash[:location] = twitter_account.address.split(',')[0].strip
    end
    if retweets.present?
      retweets.each { |retweet| p_hash[:retweet_screennames] << retweet.twitter_account.screen_name }
    end
    self.bike_index_post_hash = p_hash
  end

  
end
