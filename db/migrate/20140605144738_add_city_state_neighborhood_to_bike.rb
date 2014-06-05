class AddCityStateNeighborhoodToBike < ActiveRecord::Migration
  def change
    add_column :bikes, :city, :string
    add_column :bikes, :state, :string
    add_column :bikes, :neighborhood, :string
  end
end
