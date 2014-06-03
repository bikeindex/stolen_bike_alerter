class CreateRetweets < ActiveRecord::Migration
  def change
    create_table :retweets do |t|
      t.integer :twitter_account_id
      t.integer :tweet_id
      t.integer :twitter_tweet_id, limit: 8
      t.timestamps
    end
  end
end
