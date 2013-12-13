FactoryGirl.define do
  factory :reaction do
    user
    title 'Something happens'
    image Rack::Test::UploadedFile.new('spec/support/images/magic.gif', 'image/gif')
  end

  factory :approved_reaction, class: Reaction do
    user
    title 'Something approved happens'
    image Rack::Test::UploadedFile.new('spec/support/images/magic2.gif', 'image/gif')
    approved true
  end
end
