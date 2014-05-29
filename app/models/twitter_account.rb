class TwitterAccount < ActiveRecord::Base
  has_many :tweets
end
