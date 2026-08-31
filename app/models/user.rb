class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :authors, dependent: :destroy
  has_many :user_requests, class_name: "UserRequest", foreign_key: :created_user_id, dependent: :destroy

  normalizes :email, with: ->(e) { e.strip.downcase }
end
