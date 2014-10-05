class AddNationalToTwitterAccounts < ActiveRecord::Migration
  def change
    add_column :twitter_accounts, :is_national, :boolean, default: false, null: false
  end
end
