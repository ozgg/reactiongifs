require 'spec_helper'

describe Reaction do
  let(:user) { FactoryGirl.create(:user) }
  let(:reaction) { FactoryGirl.build(:reaction) }

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
    expect(reaction).not_to be_valid
  end
end
