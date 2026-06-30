require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  describe 'GET #show' do
    let(:user) { create(:user, email: 'owner@example.com', password: 'password') }

    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:require_authentication).and_return(true)
    end

    it 'assigns author and resource counts for the user profile' do
      author = create(:author, user: user, pen_name: 'Author One')
      create(:resource, author: author, name: 'First Resource', status: :published)
      create(:resource, author: author, name: 'Second Resource', status: :draft)

      get :show, params: { id: user.id }

      expect(controller.instance_variable_get(:@author_count)).to eq(1)
      expect(controller.instance_variable_get(:@resource_count)).to eq(2)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user, email: 'owner@example.com', password: 'password') }

    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:require_authentication).and_return(true)
    end

    it 'updates the user profile information for the current user' do
      patch :update, params: { id: user.id, user: { email: 'updated@example.com' } }

      expect(user.reload.email).to eq('updated@example.com')
      expect(response).to have_http_status(:redirect)
    end
  end
end
