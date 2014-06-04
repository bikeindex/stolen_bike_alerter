class AddBikeIdToRetweets < ActiveRecord::Migration
  def change
    add_column :retweets, :bike_id, :integer
  end
end
