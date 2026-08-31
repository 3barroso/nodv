require 'rails_helper'

RSpec.describe 'User requests', type: :request do
  it 'creates a user request with the required fields' do
    expect do
      post user_requests_path, params: {
        user_request: {
          email: 'applicant@example.com',
          first_name: 'Ada',
          last_name: 'Lovelace',
          purpose: 'Access the platform',
          reason: 'I want to contribute resources'
        }
      }
    end.to change(UserRequest, :count).by(1)

    expect(response).to have_http_status(:redirect)
    follow_redirect!
    expect(response.body).to include('Your request has been submitted')
  end
end
