require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'creation restrictions' do
    it 'prevents unapproved users from creating more than one author' do
      user = create(:user)
      # after_create should create a default author
      expect(user.authors.count).to eq(1)

      second = user.authors.build(pen_name: 'Second Author')
      expect(second.save).to be false
      expect(second.errors[:base]).to include("You must have an approved account to create more than one author")
    end

    it 'allows approved users to create multiple authors' do
      user = create(:user)
      create(:user_request, created_user: user, submitted: true, reviewed: true, approved: true)
      expect(user.approved_user_request?).to be true

      # default author exists
      expect(user.authors.count).to eq(1)

      second = user.authors.build(pen_name: 'Second Author')
      expect(second.save).to be true
      expect(user.authors.count).to eq(2)
    end

    it 'allows admin users to create multiple authors' do
      admin = create(:user, admin: true)
      # default author created
      expect(admin.authors.count).to eq(1)

      second = admin.authors.build(pen_name: 'Admin Second')
      expect(second.save).to be true
      expect(admin.authors.count).to eq(2)
    end
  end
end
