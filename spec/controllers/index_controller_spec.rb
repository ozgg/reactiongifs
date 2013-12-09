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
    let(:user) { User.create! login: 'some_guy', password: '123', password_confirmation: '123' }
    let!(:reactions) do
      [
        Reaction.create!(
          user:  user,
          title: 'Something happens',
          image: Rack::Test::UploadedFile.new('spec/support/images/magic.gif', 'image/gif')
        ),
        Reaction.create!(
          user:  user,
          title: 'Something else happens',
          image: Rack::Test::UploadedFile.new('spec/support/images/magic2.gif', 'image/gif')
        ),
      ]
    end

    describe "get index" do
      it "assigns @reactions" do
        get :index
        expect(assigns[:reactions]).to include(reactions.first, reactions.last)
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