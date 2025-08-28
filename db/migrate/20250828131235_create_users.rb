class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :name, null: false, index: { unique: true }
      t.string :provider
      t.string :uid
      t.string :password_digest

      t.timestamps
    end

    add_index :users, [:provider, :uid], unique: true
  end
end
