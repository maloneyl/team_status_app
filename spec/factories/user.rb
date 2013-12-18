FactoryGirl.define do
  factory :user do
    first_name "Alice"
    last_name "Wonders"
    email "alice@alice.com"
    password "password"
    role "member"
    confirmed_at Time.now
  end

end
