# app/models/user_request.rb
class UserRequest < ApplicationRecord
  has_one_attached :document

  belongs_to :reviewed_by, class_name: "User", optional: true
  belongs_to :created_user, class_name: "User", optional: true

  # Should this be attr_access ?
  attr_accessor :password, :password_confirmation
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, :purpose, :reason, presence: true

  validate :no_pending_requests, on: :create

  scope :pending,  -> { where(reviewed: false) }
  scope :reviewed, -> { where(reviewed: true) }
  scope :approved, -> { where(reviewed: true, approved: true) }
  scope :rejected, -> { where(reviewed: true, approved: false) }

  # Convenience status helpers
  def draft?
    !submitted && !reviewed
  end

  def submitted?
    submitted
  end

  def pending?
    submitted && !reviewed
  end

  def reviewed?
    reviewed
  end

  def approved?
    reviewed && approved
  end

  def rejected?
    reviewed && !approved
  end

  after_create :create_or_link_user

  def create_user_from_request
    return created_user if created_user.present?

    existing_user = User.find_by(email: email)
    if existing_user.present?
      update!(created_user: existing_user)
      return existing_user
    end

    generated_password = password.presence || SecureRandom.base58(12)
    confirmation_password = password_confirmation.presence || generated_password
    user = User.new(email: email, password: generated_password, password_confirmation: confirmation_password)

    if user.save
      self.created_user = user
      update_column(:created_user_id, user.id)
      user
    else
      errors.add(:base, "User account could not be created")
      user.errors.full_messages.each do |message|
        errors.add(:base, message)
      end
      raise ActiveRecord::RecordInvalid, user
    end
  end

  # Create a new draft copy of a rejected, submitted request so the user can
  # resubmit without modifying the historical record.
  def remake_rejected_request
    raise "Only valid on submitted rejected requests" unless submitted && reviewed && !approved

    attrs = attributes.except("id", "created_at", "updated_at", "reviewed", "approved", "rejection_reason", "reviewed_at", "reviewed_by_id", "created_user_id")
    new_req = UserRequest.new(attrs)
    new_req.submitted = false
    new_req.reviewed = false
    new_req.approved = false
    new_req.rejection_reason = nil
    new_req
  end

  private

  def create_or_link_user
    create_user_from_request
  end

  def no_pending_requests
    if UserRequest.pending.exists?(email: email)
      errors.add(:email, "already has a pending request")
    end
  end
end