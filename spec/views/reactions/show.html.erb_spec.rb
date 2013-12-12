require 'spec_helper'

describe 'reactions/show.html.erb' do
  let(:reaction) { FactoryGirl.create(:reaction) }

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
