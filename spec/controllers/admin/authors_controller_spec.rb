require 'rails_helper'

RSpec.describe Admin::AuthorsController, type: :controller do
  describe 'GET #show' do
    let(:admin) { create(:user, email_address: 'admin@example.com', password: 'password', admin: true) }
    let(:author) { create(:author, user: admin, pen_name: 'Test Author') }
    let!(:resource) { create(:resource, author: author, name: 'Example Resource', description: 'A published resource', status: :published) }

    before do
      allow(controller).to receive(:current_user).and_return(admin)
      allow(controller).to receive(:require_admin).and_return(true)
      allow(controller).to receive(:require_authentication).and_return(true)
      allow(controller).to receive(:ensure_author_access).and_return(true)
    end

    it 'assigns the author resources for the admin show page' do
      get :show, params: { id: author.id }

      expect(controller.instance_variable_get(:@resources)).to include(resource)
      expect(response).to have_http_status(:success)
    end
  end
end
