require 'rails_helper'

RSpec.describe 'Resources', type: :request do
  describe 'GET /resources' do
    it 'filters by parent phase and audience, and sorts by creation date' do
      parent_phase = create(:phase, name: 'Research')
      sub_phase = create(:phase, name: 'Fieldwork', parent: parent_phase)
      other_phase = create(:phase, name: 'Publishing')
      matching_audience = create(:audience_type, name: 'Researchers')
      other_audience = create(:audience_type, name: 'Public')
      author = create(:user, email: 'resources-index@example.com').authors.first

      parent_resource = create(:resource, name: 'Parent resource', status: :published, author: author)
      child_resource = create(:resource, name: 'Child resource', status: :published, author: author)
      other_audience_resource = create(:resource, name: 'Other audience resource', status: :published, author: author)
      other_phase_resource = create(:resource, name: 'Other phase resource', status: :published, author: author)
      draft_resource = create(:resource, name: 'Draft resource', status: :draft, author: author)

      create(:phase_resource, phase: parent_phase, resource: parent_resource)
      create(:phase_resource, phase: sub_phase, resource: child_resource)
      create(:phase_resource, phase: sub_phase, resource: other_audience_resource)
      create(:phase_resource, phase: other_phase, resource: other_phase_resource)
      create(:phase_resource, phase: parent_phase, resource: draft_resource)
      [ parent_resource, child_resource ].each do |resource|
        create(:resource_audience_type, resource: resource, audience_type: matching_audience)
      end
      create(:resource_audience_type, resource: other_audience_resource, audience_type: other_audience)
      create(:resource_audience_type, resource: other_phase_resource, audience_type: matching_audience)

      parent_resource.update_column(:created_at, 2.days.ago)
      child_resource.update_column(:created_at, 1.day.ago)

      get resources_path, params: {
        phase_id: parent_phase.id,
        audience_type_id: matching_audience.id,
        sort: 'created_at_asc'
      }

      expect(response).to have_http_status(:ok)
      expect(response.body.index(parent_resource.name)).to be < response.body.index(child_resource.name)
      expect(response.body).to include("#{parent_phase.name} / #{sub_phase.name}")
      expect(response.body).to include(resource_path(parent_resource), resource_path(child_resource))
      expect(response.body).not_to include(other_audience_resource.name, other_phase_resource.name, draft_resource.name)
    end

    it 'defaults to newest first and offers top-level phases in the filter' do
      parent_phase = create(:phase, name: 'Planning')
      sub_phase = create(:phase, name: 'Scoping', parent: parent_phase)
      author = create(:user, email: 'resources-sort@example.com').authors.first
      older_resource = create(:resource, name: 'Older resource', status: :published, author: author)
      newer_resource = create(:resource, name: 'Newer resource', status: :published, author: author)
      older_resource.update_column(:created_at, 2.days.ago)
      newer_resource.update_column(:created_at, 1.day.ago)

      get resources_path

      expect(response).to have_http_status(:ok)
      expect(response.body.index(newer_resource.name)).to be < response.body.index(older_resource.name)
      phase_options = Nokogiri::HTML(response.body).css("#phase_id option")
      expect(phase_options.map(&:text)).to include("All phases", parent_phase.name)
      expect(phase_options.map { |option| option["value"] }).not_to include(sub_phase.id.to_s)
    end
  end
end
