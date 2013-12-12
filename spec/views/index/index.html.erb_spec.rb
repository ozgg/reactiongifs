require 'spec_helper'

describe "index/index.html.erb" do
  context "when reactions found" do
    it "shows list with reactions" do
      reaction = FactoryGirl.create(:reaction)
      assign(:reactions, Reaction.page(1).per(5))
      render
      expect(rendered).to have_selector('ul', class: 'reactions') do |ul|
        expect(ul).to have_selector('li') do |li|
          expect(li).to contain(reaction.title)
          expect(li).to have_selector('img', src: reaction.image.url)
        end
      end
    end
  end

  context "when no reactions found" do
    it "shows message 'Реакций нет'" do
      assign(:reactions, Reaction.page(1).per(5))
      render
      expect(rendered).to contain('Реакций нет')
    end
  end
end
