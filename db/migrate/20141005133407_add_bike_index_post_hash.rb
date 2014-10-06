class AddBikeIndexPostHash < ActiveRecord::Migration
  def change
    add_column :tweets, :bike_index_post_hash, :text
  end
end
