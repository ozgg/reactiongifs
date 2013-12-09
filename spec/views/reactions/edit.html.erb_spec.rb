require 'spec_helper'

describe 'reactions/edit.html.erb' do
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
  end

  it 'displays form with title for reaction' do
    render

    expect(rendered).to have_selector('form', action: reaction_path(reaction)) do |form|
      expect(form).to have_selector('input', type: 'text', name: 'reaction[title]')
      expect(form).to have_selector('input', type: 'submit')
    end
  end

  it 'shows reaction image' do
    render

    expect(rendered).to have_selector('img', src: reaction.image.url)
  end
end
