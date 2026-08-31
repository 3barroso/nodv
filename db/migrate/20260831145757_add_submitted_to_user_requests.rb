class AddSubmittedToUserRequests < ActiveRecord::Migration[8.1]
  def change
    rename_column :user_requests, :reviewed_at, :review_confirmed_at
    
    add_column :user_requests, :submitted, :boolean, default: false
  end
end
