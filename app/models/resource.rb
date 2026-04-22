class Resource < ApplicationRecord
  has_many :phase_resources, dependent: :destroy
  has_many :phases, through: :phase_resources

  enum :status, { draft: 0, published: 1, archived: 2 }
end
