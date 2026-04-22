class Phase < ApplicationRecord

  belongs_to :parent, class_name: "Phase", optional: true
  has_many :sub_phases, class_name: "Phase", foreign_key: "parent_id", dependent: :destroy

  acts_as_list scope: :parent

  scope :main_phases, -> { where(parent_id: nil).order(:position) }
  scope :sub_phases, -> { where.not(parent_id: nil) }

  validate :prevent_deep_nesting

  private

  def prevent_deep_nesting
    if parent.present? && parent.parent.present?
      errors.add(parent_id, "phase is already a sub-phase, only one level of sub phases allowed.")
    end
  end

end
