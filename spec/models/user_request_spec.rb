require 'rails_helper'

RSpec.describe UserRequest, type: :model do
  describe 'creating a user from a request' do
    it 'creates a user and links it when the email is new' do
      request = described_class.new(
        email: 'new.user@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        first_name: 'New',
        last_name: 'User',
        purpose: 'Access the system',
        reason: 'I need to contribute'
      )

      expect { request.save! }.to change(User, :count).by(1)
      expect(request.reload.created_user).to be_present
      expect(request.created_user.email).to eq('new.user@example.com')
    end

    it 'does not create a user when the account cannot be created' do
      request = described_class.new(
        email: 'another.user@example.com',
        password: 'short',
        password_confirmation: 'different',
        first_name: 'Another',
        last_name: 'User',
        purpose: 'Access the system',
        reason: 'I need a reason'
      )

      expect { request.save }.not_to change(User, :count)
      expect(request.errors[:base]).to include('User account could not be created')
    end

    it 'does not allow a second request when one with the same email is still pending' do
      existing_request = described_class.create!(
        email: 'pending.user@example.com',
        first_name: 'Pending',
        last_name: 'User',
        purpose: 'Access the system',
        reason: 'Already requested',
        reviewed: false,
        approved: false,
        password: 'password123',
        password_confirmation: 'password123'
      )

      duplicate_request = described_class.new(
        email: existing_request.email,
        first_name: 'Duplicate',
        last_name: 'User',
        purpose: 'Access the system',
        reason: 'I need access too',
        password: 'password123',
        password_confirmation: 'password123'
      )

      expect(duplicate_request.valid?).to be(false)
      expect(duplicate_request.errors[:email]).to include('already has a pending request')
    end
  end
end
