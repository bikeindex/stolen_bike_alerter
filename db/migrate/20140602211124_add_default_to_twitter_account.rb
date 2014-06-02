class AddDefaultToTwitterAccount < ActiveRecord::Migration
  def change
    add_column :twitter_accounts, :default, :boolean, default: false
  end
end
