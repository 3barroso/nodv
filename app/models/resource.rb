class Resource < ApplicationRecord
  belongs_to :author
  has_many :phase_resources, dependent: :destroy
  has_many :phases, through: :phase_resources

  has_many :resource_audience_types, dependent: :destroy
  has_many :audience_types, through: :resource_audience_types

  enum :status, { draft: 0, published: 1, archived: 2 }, default: :draft

  def manageable_by?(user)
    return false if user.nil?
    user.admin? || author&.user_id == user.id
  end
end
