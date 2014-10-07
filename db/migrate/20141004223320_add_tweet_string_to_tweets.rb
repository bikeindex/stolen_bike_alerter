class AddTweetStringToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :tweet_string, :text
  end
end
