# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invite do
    user nil
    invitee nil
    code "MyString"
  end
end
