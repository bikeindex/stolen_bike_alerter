class ChangeTweetsColumnTwitterTweetIdToBigint < ActiveRecord::Migration
  def change
    change_column :tweets, :twitter_tweet_id, :bigint
  end
end
