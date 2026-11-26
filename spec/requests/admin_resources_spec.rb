require 'rails_helper'

RSpec.describe 'Admin::Resources', type: :request do
  before do
    allow_any_instance_of(ApplicationController).to receive(:require_authentication).and_return(true)
  end

  describe 'GET /admin/resources/:id/edit' do
    it 'shows available audience types and marks the resource audience selection' do
      owner = create(:user, email: 'resource-owner@example.com')
      resource = create(:resource, author: owner.authors.first)
      audience_type = create(:audience_type, name: 'Researchers')
      create(:resource_audience_type, resource: resource, audience_type: audience_type)
      allow_any_instance_of(Admin::ResourcesController).to receive(:current_user).and_return(owner)

      get edit_admin_resource_path(resource)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Audience types', audience_type.name)
      expect(response.body).to include('name="resource[audience_type_ids][]"')
      expect(response.body).to include('selected="selected"')
    end
  end

  describe 'PATCH /admin/resources/:id' do
    it 'associates multiple selected audience types with the resource' do
      owner = create(:user, email: 'resource-owner-update@example.com')
      resource = create(:resource, author: owner.authors.first)
      audience_types = [
        create(:audience_type, name: 'Students'),
        create(:audience_type, name: 'Educators')
      ]
      allow_any_instance_of(Admin::ResourcesController).to receive(:current_user).and_return(owner)

      patch admin_resource_path(resource), params: {
        resource: { audience_type_ids: audience_types.map(&:id) }
      }

      expect(response).to redirect_to(admin_resources_path)
      expect(resource.reload.audience_types).to match_array(audience_types)
    end
  end
end
