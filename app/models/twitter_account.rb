class TwitterAccount < ActiveRecord::Base
  has_many :tweets

  geocoded_by :address
  after_validation :geocode
end
