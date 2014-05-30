class AddTwitterAccountIndexToTweets < ActiveRecord::Migration
  def change
    add_index :tweets, :twitter_account_id
  end
end
