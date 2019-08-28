class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :twitter_uid, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet :current_sign_in_ip
      t.inet :last_sign_in_ip

      t.json :twitter_info
      t.integer :twitter_account_id
      # Uncomment below if timestamps were not included in your original model.
      t.timestamps
    end

    add_index :users, :twitter_account_id, unique: true
    add_index :users, :twitter_uid, unique: true
  end
end
