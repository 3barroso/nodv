# app/models/user_request.rb
class UserRequest < ApplicationRecord
  has_one_attached :document

  belongs_to :reviewed_by, class_name: "User", optional: true
  belongs_to :created_user, class_name: "User", optional: true

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, :purpose, :reason, presence: true
  validate :email_not_already_registered, on: :create

  scope :pending,  -> { where(reviewed: false) }
  scope :reviewed, -> { where(reviewed: true) }
  scope :approved, -> { where(reviewed: true, approved: true) }
  scope :rejected, -> { where(reviewed: true, approved: false) }

  after_create :link_existing_user

  # If a user already exists with the request email, link it as created_user.
  def link_existing_user!
    user = User.find_by(email: email)
    update!(created_user: user) if user
  end

  private

  def link_existing_user
    link_existing_user!
  end

  def email_not_already_registered
    return unless email.present?

    if User.exists?(email: email)
      errors.add(:email, "is already registered")
    end
  end
end