FactoryGirl.define do
  factory :user do
    login 'random_guy'
    password 'secret'
    password_confirmation 'secret'
  end

  factory :banned_user, class: User do
    login 'banned_guy'
    password 'secret'
    password_confirmation 'secret'
    can_post false
  end

  factory :trusted_user, class: User do
    login 'trusted_guy'
    password 'secret'
    password_confirmation 'secret'
    trusted true
  end

  factory :moderator, class: User do
    login 'mod_guy'
    password 'secret'
    password_confirmation 'secret'
    trusted true
    moderator true
  end
end
