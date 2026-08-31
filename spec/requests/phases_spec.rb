require 'rails_helper'

RSpec.describe 'Phases', type: :request do
  let!(:parent_phase) { create(:phase, name: 'Foundation Phase', description: 'Main learning stage') }
  let!(:sub_phase) { create(:phase, name: 'Sub Phase One', parent: parent_phase, description: 'A child phase') }
  let!(:author) { create(:user, email: 'ada@example.com').authors.first }
  let!(:parent_resource) { create(:resource, name: 'Parent Resource', author: author) }
  let!(:sub_resource) { create(:resource, name: 'Child Resource', author: author) }

  before do
    create(:phase_resource, phase: parent_phase, resource: parent_resource)
    create(:phase_resource, phase: sub_phase, resource: sub_resource)
  end

  it 'shows the parent phase, its sub phases, and each phase resource list' do
    get phase_path(parent_phase)

    expect(response).to have_http_status(:ok)
    expect(response.body).to include(parent_phase.name)
    expect(response.body).to include(sub_phase.name)
    expect(response.body).to include(parent_resource.name)
    expect(response.body).to include(sub_resource.name)
    expect(response.body).to include('Resources')
  end
end
