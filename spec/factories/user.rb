FactoryGirl.define do
  factory :user do
    first_name "Alice"
    last_name "Wonders"
    email "alice@alice.com"
    password "password"
    role "member"
    confirmed_at Time.now

    # trait :with_group do
    #   ignore do
    #     group_count 1
    #   end
    #   after(:create) do |user, evaluator| # evaluator gets us access to variable(s) in 'ignore'
    #     FactoryGirl.create_list :user_with_group, evaluator.group_count, user: user
    #   end
    # end

  end

end
