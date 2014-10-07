class TwitterAccount < ActiveRecord::Base
  # Attributes:  latitude, longitude, address, is_national
  #              consumer_key, consumer_secret, user_token, user_secret
  #              screen_name, twitter_account_info, language

  has_many :tweets
  serialize :twitter_account_info

  geocoded_by :address
  after_validation :geocode

  def twitter_account_url
    "https://twitter.com/#{screen_name}"
  end

  def twitter_link
    "<a href='#{twitter_account_url}'>@#{screen_name}</a>"
  end

  def get_account_info
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = consumer_key
      config.consumer_secret     = consumer_secret
      config.access_token        = user_token
      config.access_token_secret = user_secret
    end
    result = client.user(screen_name)
    self.twitter_account_info = result.to_h
  end

  def account_info_name
    return nil unless twitter_account_info.present?
    twitter_account_info[:name]
  end

  def account_info_image
    return nil unless twitter_account_info.present?
    twitter_account_info[:profile_image_url_https]
  end

end
