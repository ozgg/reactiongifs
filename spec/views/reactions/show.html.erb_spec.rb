require 'spec_helper'

describe 'reactions/show.html.erb' do
  let(:user) { User.create! login: 'some_guy', password: '123', password_confirmation: '123' }
  let(:reaction) do
    Reaction.create!(
      user:  user,
      title: 'Something happens',
      image: Rack::Test::UploadedFile.new('spec/support/images/magic.gif', 'image/gif')
    )
  end

  before :each do
    assign :reaction, reaction
    render
  end

  it 'displays reaction title' do
    expect(rendered).to contain(reaction.title)
  end

  it 'displays reaction image' do
    expect(rendered).to have_selector('img', src: reaction.image.url)
  end
end
