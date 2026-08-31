require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe 'publishing validation' do
    it 'is invalid to publish when the author\'s user is not approved' do
      user = create(:user)
      author = user.authors.first

      resource = build(:resource, author: author, status: :draft)
      resource.status = :published

      expect(resource).not_to be_valid
      expect(resource.errors[:status]).to include("cannot be set to published: owning user has not been approved")
    end

    it 'is valid to publish when the author\'s user has an approved request' do
      user = create(:user)
      create(:user_request, created_user: user, submitted: true, approved: true)
      author = create(:author, user: user)

      resource = build(:resource, author: author, status: :draft)
      resource.status = :published

      expect(resource).to be_valid
    end
  end
end
