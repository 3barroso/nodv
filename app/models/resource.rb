class Resource < ApplicationRecord
  has_many :phase_resources, dependent: :destroy
  has_many :phases, through: :phase_resources
end
