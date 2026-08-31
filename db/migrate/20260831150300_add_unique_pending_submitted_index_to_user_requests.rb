class AddUniquePendingSubmittedIndexToUserRequests < ActiveRecord::Migration[8.1]
  def change
    # Remove the older partial index on unreviewed email if present
    if index_exists?(:user_requests, name: "index_user_requests_on_unreviewed_email")
      remove_index :user_requests, name: "index_user_requests_on_unreviewed_email"
    end

    # Add a unique partial index so only one submitted pending request per email can exist
    add_index :user_requests, :email, unique: true, name: "index_user_requests_on_pending_submitted_email", where: "reviewed = false AND submitted = true"
  end
end
