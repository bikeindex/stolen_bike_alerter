class AddBikeIndexBikeIdToBikes < ActiveRecord::Migration
  def change
    add_column :bikes, :bike_index_bike_id, :integer
  end
end
