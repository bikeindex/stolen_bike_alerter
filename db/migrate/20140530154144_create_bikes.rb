class CreateBikes < ActiveRecord::Migration
  def change
    create_table :bikes do |t|
      t.string :bike_index_api_url
      t.text :bike_index_api_response

      t.timestamps
    end
  end
end
