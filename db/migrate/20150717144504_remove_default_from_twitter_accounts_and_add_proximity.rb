class RemoveDefaultFromTwitterAccountsAndAddProximity < ActiveRecord::Migration
  def change
    remove_column :twitter_accounts, :default, :boolean, default: false, null: false
    add_column :twitter_accounts, :proximity, :integer, default: 50
  end
end
