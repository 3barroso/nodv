class ResourceAudienceType < ApplicationRecord
  belongs_to :resource
  belongs_to :audience_type
end
