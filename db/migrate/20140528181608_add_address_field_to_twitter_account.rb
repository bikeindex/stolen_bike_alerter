class AddAddressFieldToTwitterAccount < ActiveRecord::Migration
  def change
    add_column :twitter_accounts, :address, :string
  end
end
