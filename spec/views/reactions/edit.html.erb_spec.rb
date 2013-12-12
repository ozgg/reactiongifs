require 'spec_helper'

describe "reactions/edit.html.erb" do
  let(:reaction) { FactoryGirl.create(:reaction) }

  before(:each) do
    assign :reaction, reaction
    render
  end

  it "displays form with title for reaction" do
    expect(rendered).to have_selector('form', action: reaction_path(reaction)) do |form|
      expect(form).to have_selector('input', type: 'text', name: 'reaction[title]')
      expect(form).to have_selector('input', type: 'submit')
    end
  end

  it "shows reaction image" do
    expect(rendered).to have_selector('img', src: reaction.image.url)
  end
end
