require 'spec_helper'

describe IndexController do
  context "in all cases" do
    describe "get index" do
      it "renders index/index view" do
        get :index
        expect(response).to render_template('index/index')
      end
    end
  end

  context "when reactions found" do
    describe "get index" do
      it "assigns @reactions" do
        reaction = FactoryGirl.create(:reaction)

        get :index
        expect(assigns[:reactions]).to include(reaction)
      end
    end
  end

  context "when no reactions found" do
    describe "get index" do
      it "assigns empty @reactions" do
        get :index
        expect(assigns[:reactions]).to be_empty
      end
    end
  end
end