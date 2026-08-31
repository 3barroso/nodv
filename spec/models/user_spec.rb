require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'after_create default author' do
    it 'creates a default author when a user is created without authors' do
      user = create(:user, email: 'jane.doe@example.com')

      expect(user.authors.count).to eq(1)
      expect(user.authors.first.pen_name).to be_present
    end

    it 'does not create an extra author on update' do
      user = create(:user, email: 'sam@example.com')
      # default author created on after_create
      expect(user.authors.count).to eq(1)

      # update should not create another default author
      user.update(email: 'sam2@example.com')
      expect(user.authors.count).to eq(1)
    end
  end
end
