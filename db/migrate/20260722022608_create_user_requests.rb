class CreateUserRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :user_requests do |t|

      t.string :email, null: false
      t.string :first_name
      t.string :last_name
      t.text :reason
      t.text :purpose

      t.boolean :reviewed, null: false, default: false
      t.boolean :approved, null: false, default: false
      t.text :rejection_reason
      t.references :reviewed_by, foreign_key: { to_table: :users }, null: true
      t.datetime :reviewed_at

      t.references :created_user, foreign_key: { to_table: :users }, null: true

      t.timestamps
    end

    add_index :user_requests, :email
    add_index :user_requests, :email, unique: true, where: "reviewed = false", name: "index_user_requests_on_unreviewed_email"
    add_index :user_requests, [:reviewed, :created_at]
  end
end
