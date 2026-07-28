require 'rails_helper'

RSpec.describe 'Admin::UserRequests', type: :request do
  before do
    allow_any_instance_of(ApplicationController).to receive(:require_authentication).and_return(true)
  end
  describe 'GET /admin/user_requests' do
    it 'shows pending requests and metrics to admin' do
      create_list(:user_request, 2, reviewed: false)
      create(:user_request, reviewed: true, approved: true)

      admin = create(:user, admin: true, email: 'admin@example.com')
      allow_any_instance_of(Admin::UserRequestsController).to receive(:current_user).and_return(admin)

      get admin_user_requests_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Total requests:')
      expect(response.body).to include('Approved requests:')
    end
  end

  describe 'GET /admin/user_requests/:id/edit' do
    it 'renders owner edit when current session user matches request email' do
      req = create(:user_request, email: 'owner@example.com')
      owner_stub = double('User', email: 'owner@example.com', admin?: false)
      allow_any_instance_of(Admin::UserRequestsController).to receive(:current_user).and_return(owner_stub)

      get edit_admin_user_request_path(req)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Edit your request')
    end

    it 'renders reviewer edit when current_user is admin' do
      admin = create(:user, admin: true, email: 'admin2@example.com')
      allow_any_instance_of(Admin::UserRequestsController).to receive(:current_user).and_return(admin)

      req = create(:user_request, email: 'someone@example.com')

      get edit_admin_user_request_path(req)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Review user request')
    end
  end
end
