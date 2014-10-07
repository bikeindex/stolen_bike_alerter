class AddLanguageToTwitterAccount < ActiveRecord::Migration
  def change
    add_column :twitter_accounts, :language, :string
  end
end
