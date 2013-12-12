FactoryGirl.define do
  factory :user do
    login 'random_guy'
    password 'secret'
    password_confirmation 'secret'
  end
end
