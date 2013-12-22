FactoryGirl.define do
  factory :user do
    sequence(:login) { |n| "random_guy#{n}" }
    password 'secret'
    password_confirmation 'secret'

    factory :banned_user do
      can_post false
    end

    factory :trusted_user do
      trusted true
    end

    factory :moderator do
      moderator true
    end
  end
end
