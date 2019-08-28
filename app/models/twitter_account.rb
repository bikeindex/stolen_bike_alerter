class TwitterAccount < ActiveRecord::Base
  scope :active, -> { where(is_active: true) }
  scope :national, -> { active.where(is_national: true) }
  has_many :tweets
  has_many :retweets
  has_one :user
  serialize :twitter_account_info
  attr_accessor :no_geocode

  geocoded_by :address
  after_validation :geocode, if: lambda {
              !self.no_geocode && self.address.present? && (latitude.blank? || self.address_changed?)
            }

  before_save :reverse_geocode, if: lambda {
                      !self.no_geocode && self.latitude.present? && (state.blank? || self.state_changed?)
                    }
  reverse_geocoded_by :latitude, :longitude do |account, results|
    if geo = results.first
      account.country = geo.country
      account.city = geo.city
      account.state = geo.state_code
      account.neighborhood = geo.neighborhood
    end
  end

  def self.attrs_from_user_info(info)
    {
      screen_name: info["info"]["nickname"],
      address: info["info"]["location"],
      consumer_key: ENV["OMNIAUTH_CONSUMER_KEY"],
      consumer_secret: ENV["OMNIAUTH_CONSUMER_SECRET"],
      user_token: info["credentials"]["token"],
      user_secret: info["credentials"]["secret"],
    }
  end

  def self.create_from_twitter_oauth(info)
    self.create(attrs_from_user_info(info))
  end

  def self.fuzzy_screen_name_find(n)
    if !n.blank?
      self.where("lower(screen_name) = ?", n.downcase.strip).first
    else
      nil
    end
  end

  def self.default_account
    self.where(default: true).first || self.national.first
  end

  def self.default_account_for_country(c)
    account = self.national.where(country: c).first
    account.present? ? account : default_account
  end

  def twitter_account_url
    "https://twitter.com/#{screen_name}"
  end

  def twitter_link
    "<a href='#{twitter_account_url}'>@#{screen_name}</a>"
  end

  def get_account_info
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = consumer_key
      config.consumer_secret = consumer_secret
      config.access_token = user_token
      config.access_token_secret = user_secret
    end
    client.user(screen_name).to_h
  end

  before_save :set_account_info

  def set_account_info
    self.twitter_account_info ||= get_account_info
  end

  def account_info_name
    twitter_account_info.present? ? twitter_account_info[:name] : nil
  end

  def account_info_image
    twitter_account_info.present? ? twitter_account_info[:profile_image_url_https] : nil
  end
end
