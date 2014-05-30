class Tweet < ActiveRecord::Base
  belongs_to :twitter_account, dependent: :destroy

  validates_presence_of :twitter_account_id
end
