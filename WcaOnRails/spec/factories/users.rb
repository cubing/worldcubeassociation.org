FactoryGirl.define do
  factory :user, aliases: [:author] do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "foo"
    password_confirmation { "foo" }
    after(:create) { |user| user.confirm! }

    factory :admin do
      name "Mr. Admin"
      email "admin@worldcubeassociation.org"
      admin true
    end

    factory :results_team do
      results_team true
    end

    factory :delegate do
      delegate_status "delegate"
    end

    factory :board_member do
      delegate_status "board_member"
    end
  end
end
