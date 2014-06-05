class AddLatitudeLongitudeToBike < ActiveRecord::Migration
  def change
    add_column :bikes, :latitude, :float
    add_column :bikes, :longitude, :float
  end
end
