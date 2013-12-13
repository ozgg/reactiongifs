FactoryGirl.define do
  factory :user do
    login 'random_guy'
    password 'secret'
    password_confirmation 'secret'
  end

  factory :active_user, class: User do
    login 'active_guy'
    password 'secret'
    password_confirmation 'secret'
    can_post true
  end

  factory :trusted_user, class: User do
    login 'trusted_guy'
    password 'secret'
    password_confirmation 'secret'
    can_post true
    trusted true
  end

  factory :moderator, class: User do
    login 'mod_guy'
    password 'secret'
    password_confirmation 'secret'
    can_post true
    trusted true
    moderator true
  end
end
