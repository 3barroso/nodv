require 'rails_helper'

RSpec.describe UserRequestsController, type: :controller do
  describe 'GET #new remake/redirect flows' do
    let(:user) { create(:user) }

    it 'creates a new draft from a rejected submitted request' do
      rejected = create(:user_request, email: user.email, submitted: true, reviewed: true, approved: false)
      allow(controller).to receive(:current_user).and_return(user)

      get :new

      ur = controller.instance_variable_get(:@user_request)
      expect(ur).to be_a_new(UserRequest)
      expect(ur.email).to eq(user.email)
      expect(ur.submitted).to be_falsey
    end

    it 'redirects to admin show when latest request is submitted and pending review' do
      pending_request = create(:user_request, email: user.email, submitted: true, reviewed: false)
      allow(controller).to receive(:current_user).and_return(user)

      get :new

      expect(response).to redirect_to(admin_user_request_path(pending_request))
    end
  end
end
