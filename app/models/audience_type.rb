class AudienceType < ApplicationRecord
  has_many :resource_audience_types, dependent: :destroy
  has_many :resources, through: :resource_audience_types

  validates :name, presence: true, uniqueness: true
end
