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

      it "adds flash message 'Реакция обновлена'" do
        patch :update, id: reaction, reaction: { title: 'new title' }
        expect(flash[:notice]).to eq('Реакция обновлена')
      end
    end

    describe "delete destroy" do
      it "removes reaction from database" do
        delete :destroy, id: reaction
        expect{reaction.reload}.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "redirects to root page" do
        delete :destroy, id: reaction
        expect(response).to redirect_to(root_path)
      end

      it "adds flash message 'Реакция удалена'" do
        delete :destroy, id: reaction
        expect(flash[:notice]).to eq('Реакция удалена')
      end
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
      before :each do
        get :show, id: reaction.id
      end

      it "renders view with reaction" do
        expect(response).to render_template('reactions/show')
      end

      it "sets reaction for view" do
        expect(assigns[:reaction]).to eq(reaction)
      end
    end
  end
end
