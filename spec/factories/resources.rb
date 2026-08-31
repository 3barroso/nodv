FactoryBot.define do
  factory :resource do
    name { "MyString" }
    status { :draft }

    after(:build) do |resource|
      # If factory sets status to published, ensure the owning user has an approved request
      if resource.status.to_s == 'published'
        user = resource.author&.user || create(:user)
        unless user.user_requests.where(submitted: true, approved: true).exists?
          create(:user_request, created_user: user, submitted: true, reviewed: true, approved: true)
        end
      end
    end
  end
end
