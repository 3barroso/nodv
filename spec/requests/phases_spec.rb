require 'rails_helper'

RSpec.describe 'Phases', type: :request do
  describe 'GET /phases' do
    it 'lists phases by position with published resources under parents and sub-phases' do
      first_phase = create(:phase, name: 'Zulu First Phase')
      sub_phase = create(:phase, name: 'Nested Sub-Phase', parent: first_phase)
      second_sub_phase = create(:phase, name: 'Second Nested Sub-Phase', parent: first_phase)
      second_phase = create(:phase, name: 'Alpha Second Phase')
      author = create(:user, email: 'phase-index@example.com').authors.first

      parent_resource = create(:resource, name: 'Published Parent Resource', status: :published, author: author)
      sub_resource = create(:resource, name: 'Published Sub-Phase Resource', status: :published, author: author)
      second_sub_resource = create(:resource, name: 'Second Published Sub-Phase Resource', status: :published, author: author)
      draft_resource = create(:resource, name: 'Hidden Draft Resource', status: :draft, author: author)
      create(:phase_resource, phase: first_phase, resource: parent_resource)
      create(:phase_resource, phase: first_phase, resource: draft_resource)
      create(:phase_resource, phase: sub_phase, resource: sub_resource)
      create(:phase_resource, phase: second_sub_phase, resource: second_sub_resource)

      get phases_path

      expect(response).to have_http_status(:ok)
      expect(response.body.index(first_phase.name)).to be < response.body.index(parent_resource.name)
      expect(response.body.index(parent_resource.name)).to be < response.body.index(sub_phase.name)
      expect(response.body.index(sub_phase.name)).to be < response.body.index(sub_resource.name)
      expect(response.body.index(sub_resource.name)).to be < response.body.index(second_phase.name)
      expect(response.body.index(sub_resource.name)).to be < response.body.index(second_sub_phase.name)
      expect(response.body.index(second_sub_phase.name)).to be < response.body.index(second_sub_resource.name)
      expect(response.body).not_to include(draft_resource.name)
      expect(response.body).to include(resource_path(parent_resource), resource_path(sub_resource), resource_path(second_sub_resource))

      document = Nokogiri::HTML(response.body)
      expect(document.css("button[data-phase-disclosure-target='button'][aria-expanded='true']").count).to eq(Phase.count)
      expect(document.at_css("h2 a[href='#{phase_path(first_phase)}']")&.text).to eq(first_phase.name)
    end
  end

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
