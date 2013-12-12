require 'spec_helper'

describe "reactions/index.html.erb" do
  context "when reactions found" do
    it "shows list with reactions" do
      reaction = FactoryGirl.create(:reaction)
      assign(:reactions, Reaction.page(1).per(20))
      render
      expect(rendered).to have_selector('ul') do |ul|
        expect(ul).to have_selector('li') do |li|
          expect(li).to have_selector('a', href: edit_reaction_path(reaction))
          expect(li).to contain(reaction.title)
        end
      end
    end
  end

  context "when no reactions found" do
    it "shows message 'Реакций нет'" do
      assign(:reactions, Reaction.all)
      render
      expect(rendered).to contain('Реакций нет')
    end
  end
end
