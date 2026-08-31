class Resource < ApplicationRecord
  belongs_to :author
  has_many :phase_resources, dependent: :destroy
  has_many :phases, through: :phase_resources

  has_many :resource_audience_types, dependent: :destroy
  has_many :audience_types, through: :resource_audience_types

  enum :status, { draft: 0, published: 1, archived: 2 }, default: :draft

  validate :user_must_be_approved_for_publish

  def manageable_by?(user)
    return false if user.nil?
    user.admin? || author&.user_id == user.id
  end

  private

    def user_must_be_approved_for_publish
      # If status is being set to published (on create or update), ensure the owning user has an approved request.
      if will_save_change_to_status? && status == "published"
        user = author&.user
        unless user&.approved_user_request?
          errors.add(:status, "cannot be set to published: owning user has not been approved")
        end
      end
    end
end
