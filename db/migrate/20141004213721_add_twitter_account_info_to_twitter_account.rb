class AddTwitterAccountInfoToTwitterAccount < ActiveRecord::Migration
  def change
    add_column :twitter_accounts, :twitter_account_info, :text
  end
end
