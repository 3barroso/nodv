class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :authors, dependent: :destroy
  has_many :user_requests, class_name: "UserRequest", foreign_key: :created_user_id, dependent: :destroy

  normalizes :email, with: ->(e) { e.strip.downcase }

  # Returns true if this user has at least one submitted user request that was approved.
  def approved_user_request?
    user_requests.where(approved: true).exists?
  end
end
