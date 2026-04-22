class Resource < ApplicationRecord
  has_many :phase_resources, dependent: :destroy
  has_many :phases, through: :phase_resources

  has_many :resource_audience_types, dependent: :destroy
  has_many :audience_types, through: :resource_audience_types

  enum :status, { draft: 0, published: 1, archived: 2 }
end
