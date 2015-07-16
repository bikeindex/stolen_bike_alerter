class AddActiveToTwitterAccounts < ActiveRecord::Migration
  def change
    add_column :twitter_accounts, :is_active, :boolean, default: false, null: false
    add_column :twitter_accounts, :append_block, :string
  end
end
