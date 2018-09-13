class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable,
         :trackable, :omniauthable, :omniauth_providers => [:twitter]

  belongs_to :twitter_account

  def self.from_omniauth(uid, auth)
    where(twitter_uid: uid).first_or_create do |user|
      user.twitter_info = auth.to_h
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      raise StandardError
      if data = session["devise.bike_index_email"] && session["devise.bike_index_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def screen_name
    twitter_info && twitter_info['info'] && twitter_info['info']['nickname']
  end

  def twitter_url
    "https://twitter.com/#{screen_name}"
  end

  def twitter_credentials
    (twitter_info['credentials'] || {}).with_indifferent_access
  end

  def update_twitter_info(info=twitter_info)
    new_info = info.to_h
    self.update_attribute :twitter_info, new_info unless twitter_info == new_info
    account = find_or_create_associated_twitter_account
    self.update_attribute :twitter_account_id, account.id unless account.id == twitter_account_id
  end

  def find_or_create_associated_twitter_account
    if account_by_screen_name.present?
      account_by_screen_name.update_attributes(TwitterAccount.attrs_from_user_info(twitter_info))
    else
      TwitterAccount.create_from_twitter_oauth(twitter_info)
    end
  end

  def account_by_screen_name
    @account_by_screen_name ||= TwitterAccount.fuzzy_screen_name_find(screen_name)
  end
end