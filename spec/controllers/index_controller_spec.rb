require 'spec_helper'

describe IndexController do
  shared_examples "index/index view renderer" do
    it "renders index/index view" do
      get :index
      expect(response).to render_template('index/index')
    end
  end

  context "when reactions found" do
    describe "get index" do
      it_should_behave_like "index/index view renderer"

      it "assigns @reactions with approved reactions" do
        reaction = FactoryGirl.create(:approved_reaction)

        get :index
        expect(assigns[:reactions]).to include(reaction)
      end

      it "assigns @reactions without unapproved reactions" do
        reaction = FactoryGirl.create(:reaction)

        get :index
        expect(assigns[:reactions]).not_to include(reaction)
      end
    end
  end

  context "when no reactions found" do
    describe "get index" do
      it_should_behave_like "index/index view renderer"

      it "assigns empty @reactions" do
        get :index
        expect(assigns[:reactions]).to be_empty
      end
    end
  end
end