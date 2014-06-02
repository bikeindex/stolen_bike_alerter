class AddLatitudeLongitudeIndexToTwitterAccount < ActiveRecord::Migration
  def change
    add_index :twitter_accounts, [:latitude, :longitude]
  end
end
