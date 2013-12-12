FactoryGirl.define do
  factory :reaction do
    user
    title 'Something happens'
    image Rack::Test::UploadedFile.new('spec/support/images/magic.gif', 'image/gif')
  end
end
