class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.references :user, foreign_key: true
      t.references :campaign, null: false, foreign_key: true
      t.string :email, null: false
      t.string :token, null: false, index: { unique: true, name: "unique_token" }
      t.datetime :accepted_at
      t.datetime :rejected_at

      t.timestamps
    end
  end
end
