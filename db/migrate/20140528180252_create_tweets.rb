class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :twitter_account_id
      t.integer :twitter_tweet_id

      t.timestamps
    end
  end
end
