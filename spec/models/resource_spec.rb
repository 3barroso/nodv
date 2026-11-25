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

  describe '#markdown_content' do
    it 'renders the Action Text plain-text body as Markdown' do
      resource = Resource.new
      resource.description = "## Frequently asked questions\n\n**Important** details."

      expect(resource.markdown_content).to include('<h2')
      expect(resource.markdown_content).to include('<strong>Important</strong>')
    end

    it 'preserves formatting saved by the rich-text editor' do
      resource = Resource.new
      resource.description = '<p><strong>Important</strong> details.</p>'

      expect(resource.markdown_content).to include('<strong>Important</strong>')
    end
  end
end
