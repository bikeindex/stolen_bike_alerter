class Tweet < ActiveRecord::Base
  belongs_to :twitter_account
  belongs_to :bike

  validates_presence_of :twitter_account_id
  validates_presence_of :bike_id
end
