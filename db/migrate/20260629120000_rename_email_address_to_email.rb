class RenameEmailAddressToEmail < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :email_address, :email

    if index_name_exists?(:users, :index_users_on_email_address)
      remove_index :users, name: :index_users_on_email_address
    end

    unless index_name_exists?(:users, :index_users_on_email)
      add_index :users, :email, unique: true, name: :index_users_on_email
    end
  end
end
