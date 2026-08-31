require 'rails_helper'

RSpec.describe UserRequestsController, type: :controller do
  describe 'POST #create' do
    let(:email) { 'same@example.com' }
    let(:user) { create(:user, email: email) }

    before do
      create(:user_request, email: email, reviewed: true, approved: true, created_user: user)
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:start_new_session_for)
    end

    it 'allows a signed-in user with the same email to submit a new request' do
      expect do
        post :create, params: {
          user_request: {
            email: email,
            password: 'password123',
            password_confirmation: 'password123',
            first_name: 'Signed',
            last_name: 'In',
            purpose: 'Access the system',
            reason: 'I need access'
          }
        }
      end.to change(UserRequest, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(controller).to have_received(:start_new_session_for).with(user)
    end

    it 'redirects unauthenticated existing user to login with neutral notice' do
      # simulate no current_user
      allow(controller).to receive(:current_user).and_return(nil)

      # ensure user exists in DB
      user

      expect do
        post :create, params: {
          user_request: {
            email: email,
            password: 'password123',
            password_confirmation: 'password123',
            first_name: 'Anon',
            last_name: 'Visitor',
            purpose: 'Access',
            reason: 'I need access'
          }
        }
      end.not_to change(UserRequest, :count)

      expect(response).to redirect_to(new_session_path)
      expect(flash[:notice]).to match(/System is processing your request/)
    end
  end
end
