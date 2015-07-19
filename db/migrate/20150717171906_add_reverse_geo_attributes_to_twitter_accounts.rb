class AddReverseGeoAttributesToTwitterAccounts < ActiveRecord::Migration
  def change
    add_column :bikes, :country, :string
    add_column :twitter_accounts, :country, :string
    add_column :twitter_accounts, :city, :string
    add_column :twitter_accounts, :state, :string
    add_column :twitter_accounts, :neighborhood, :string
  end
end
