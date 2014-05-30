class AddBikeIdToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :bike_id, :integer
  end
end
