class CreateTwitterAccounts < ActiveRecord::Migration
  def change
    create_table :twitter_accounts do |t|
      t.string :screen_name
      t.float :latitude
      t.float :longitude
      t.string :consumer_key
      t.string :consumer_secret
      t.string :user_token
      t.string :user_secret

      t.timestamps
    end
  end
end
