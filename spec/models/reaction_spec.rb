require 'spec_helper'

describe Reaction do
  let(:user) { User.create! login: 'some_guy', password: '123', password_confirmation: '123' }
  let(:reaction) do
    Reaction.new(
        user: user,
        title: 'Something happens',
        image: Rack::Test::UploadedFile.new('spec/support/images/magic.gif', 'image/gif')
    )
  end

  it "is valid when has user, title and image" do
    expect(reaction).to be_valid
  end

  it "is invalid without user" do
    reaction.user = nil
    expect(reaction).not_to be_valid
  end

  it "is invalid without title" do
    reaction.title = ' '
    expect(reaction).not_to be_valid
  end

  it "trims title before validating" do
    reaction.title = '   When I trim   '
    reaction.valid?
    expect(reaction.title).to eq('When I trim')
  end

  it "is invalid without image" do
    reaction = Reaction.new(user: user, title: 'No image')
    expect(reaction).not_to be_valid
  end

  it "can have only image/gif as image" do
    reaction.image = Rack::Test::UploadedFile.new('spec/support/images/man.jpg', 'image/jpg')
    expect{reaction.save}.not_to change{ reaction.image }
  end
end
