class Author < ApplicationRecord
  belongs_to :user
  has_many :resources, dependent: :destroy
  has_many :published_resources, -> { published }, class_name: "Resource"

  validates :pen_name, presence: true, uniqueness: { scope: :user_id,
    message: "you already have an author profile with this name" }

  after_save :ensure_single_primary, if: :became_primary?

  def user_email
    user.respond_to?(:email) ? user.email : nil
  end

  def user_admin
    user.respond_to?(:admin) ? user.admin : nil
  end

  def manageable_by?(user)
    return false if user.nil?
    user.admin? || self.user_id == user.id
  end

  private

    def became_primary?
      primary? && saved_change_to_primary?
    end

    def ensure_single_primary
      user.authors.where.not(id: id).update_all(primary: false)
    end
end
