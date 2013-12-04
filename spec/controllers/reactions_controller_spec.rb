require 'spec_helper'

describe ReactionsController do
  let(:user) { User.create!(login: 'some_guy', password: '123', password_confirmation: '123') }
  let(:reaction_parameters) do
    {
        user:  user,
        title: 'Something happens',
        image: Rack::Test::UploadedFile.new('spec/support/images/magic.gif'),
    }
  end
  let(:reaction) { Reaction.create!(reaction_parameters) }

  context "User is logged in" do
    before :each do
      session[:user_id] = user.id
    end

    describe "get new" do
      it "renders view with reaction form" do
        get :new
        expect(response).to render_template('reactions/new')
      end
    end

    describe "post create" do
      it "creates new reaction" do
        expect{post :create, reaction: reaction_parameters}.to change(Reaction, :count).by(1)
      end

      it "redirects to reaction page" do
        post :create, { reaction: reaction_parameters }
        expect(response).to redirect_to(Reaction.last)
      end

      it "adds flash message 'Реакция добавлена'" do
        post :create, { reaction: reaction_parameters }
        expect(flash[:message]).to eq('Реакция добавлена')
      end
    end

    describe "patch update" do
      it "updates reaction title" do
        patch :update, id: reaction, reaction: { title: 'new title' }
        reaction.reload
        expect(reaction.title).to eq('new title')
      end

      it "ignores new reaction image" do
        parameters = {
            id: reaction,
            reaction: {
                image: Rack::Test::UploadedFile.new('spec/support/images/magic.gif')
            }
        }
        expect{patch :update, parameters}.not_to change(reaction, :image)
      end

      it "redirects to reaction page" do
        patch :update, id: reaction, reaction: { title: 'new title' }
        expect(response).to redirect_to(reaction)
      end
    end

    describe "delete destroy" do
      it "removes reaction from database"
      it "redirects to root page"
      it "adds flash message 'Реакция удалена'"
    end
  end

  context "User is not logged in" do
    describe "get new" do
      it "redirects to login page"
      it "adds flash message 'Необходима авторизация'"
    end

    describe "post create" do
      it "redirects to login page"
      it "adds flash message 'Необходима авторизация'"
    end

    describe "patch update" do
      it "redirects to login page"
      it "adds flash message 'Необходима авторизация'"
    end
  end

  context "Any user" do
    describe "get show" do
      it "renders view with reaction"
    end
  end

  context "When has errors" do
    describe "Invalid creation parameters" do
      it "renders new reaction form"
      it "leaves reactions table intact"
    end

    describe "Updating image" do
      it "renders edited reaction form"
      it "leaves reaction intact"
    end
  end
end