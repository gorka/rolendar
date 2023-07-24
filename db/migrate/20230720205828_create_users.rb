class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email
      t.string :omniauth_developer_uid
      t.string :discord_uid

      t.timestamps
    end
  end
end
