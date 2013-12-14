require 'spec_helper'

describe "reactions/pending.html.erb" do
  context "when @reactions is not empty" do
    it "shows list with reactions" do
      reaction = FactoryGirl.create(:reaction)
      assign(:reactions, Reaction.page(1).per(20))
      render
      expect(rendered).to have_selector('ul') do |ul|
        expect(ul).to have_selector('li') do |li|
          expect(li).to have_selector('a', href: edit_reaction_path(reaction))
          expect(li).to contain(reaction.title)
          expect(li).to contain(reaction.user.login)
        end
      end
    end
  end

  context "when @reactions is empty" do
    it "shows message 'Реакций нет'" do
      assign(:reactions, Reaction.page(1).per(20))
      render
      expect(rendered).to contain(I18n.t('notices.reactions.empty_list'))
    end
  end
end
