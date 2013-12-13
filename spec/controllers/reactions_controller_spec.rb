require 'spec_helper'

describe ReactionsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:reaction_parameters) { FactoryGirl.attributes_for(:reaction, user: user) }
  let!(:reaction) { FactoryGirl.create(:reaction, user: user) }

  shared_examples "restricted area" do
    it "redirects to login page" do
      expect(response).to redirect_to(login_path)
    end

    it "adds flash message 'Недостаточно прав'" do
      expect(flash[:notice]).to eq(I18n.t('authorization.insufficient_rights'))
    end
  end

  shared_examples "viewable reaction page" do
    describe "get show" do
      before(:each) { get :show, id: reaction.id }

      it "renders view with reaction" do
        expect(response).to render_template('reactions/show')
      end

      it "assigns @reaction" do
        expect(assigns[:reaction]).to eq(reaction)
      end
    end
  end

  context "Active user is logged in" do
    before(:each) { session[:user_id] = user.id }

    describe "get new" do
      it "renders reactions/new view" do
        get :new
        expect(response).to render_template('reactions/new')
      end
    end

    describe "post create" do
      it "creates new reaction" do
        expect { post :create, reaction: reaction_parameters }.to change(Reaction, :count).by(1)
      end

      it "redirects to reaction page" do
        post :create, reaction: reaction_parameters
        expect(response).to redirect_to(Reaction.last)
      end

      it "adds flash message 'Реакция добавлена'" do
        post :create, reaction: reaction_parameters
        expect(flash[:message]).to eq('Реакция добавлена')
      end

      it "adds unapproved reaction" do
        post :create, reaction: reaction_parameters
        expect(Reaction.last).not_to be_approved
      end
    end

    describe "get index" do
      before(:each) { get :index }

      it_should_behave_like "restricted area"
    end

    describe "get edit" do
      before(:each) { get :edit, id: reaction }

      it_should_behave_like "restricted area"
    end

    describe "path update" do
      before(:each) { patch :update, id: reaction, title: 'new title' }

      it_should_behave_like "restricted area"
    end

    describe "delete destroy" do
      before(:each) { delete :destroy, id: reaction }

      it_should_behave_like "restricted area"
    end

    it_should_behave_like "viewable reaction page"
  end

  context "Trusted user is logged in" do
    let(:trusted_user) { FactoryGirl.create(:trusted_user) }

    before(:each) { session[:user_id] = trusted_user.id }

    describe "post create" do
      it "adds approved reaction" do
        post :create, reaction: reaction_parameters
        expect(Reaction.last).to be_approved
      end
    end

    it_should_behave_like "viewable reaction page"
  end

  context "Moderator is logged in" do
    let(:moderator) { FactoryGirl.create(:moderator) }

    before(:each) { session[:user_id] = moderator.id }

    describe "get index" do
      before(:each) { get :index }

      it "renders reactions/index view" do
        expect(response).to render_template('reactions/index')
      end

      it "assigns @reactions" do
        expect(assigns[:reactions]).to include(reaction)
      end
    end

    describe "get edit" do
      it "renders reactions/edit view" do
        get :edit, id: reaction.id
        expect(response).to render_template('reactions/edit')
      end

      it "assigns @reaction" do
        get :edit, id: reaction.id
        expect(assigns[:reaction]).to eq(reaction)
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
            id:       reaction,
            reaction: {
                image: Rack::Test::UploadedFile.new('spec/support/images/magic2.gif')
            }
        }
        expect { patch :update, parameters }.not_to change(reaction, :image)
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
        expect { reaction.reload }.to raise_error(ActiveRecord::RecordNotFound)
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

    it_should_behave_like "viewable reaction page"
  end

  context "User is not logged in" do
    before(:each) { session[:user_id] = nil }

    describe "get new" do
      before(:each) { get :new }

      it_should_behave_like "restricted area"
    end

    describe "post create" do
      before(:each) { post :create }

      it_should_behave_like "restricted area"
    end

    describe "patch update" do
      before(:each) { patch :update, id: reaction.id }

      it_should_behave_like "restricted area"
    end

    describe "get edit" do
      before(:each) { get :edit, id: reaction.id }

      it_should_behave_like "restricted area"
    end

    describe "get index" do
      before(:each) { get :index }

      it_should_behave_like "restricted area"
    end

    it_should_behave_like "viewable reaction page"
  end

  context "Banned user is logged in" do
    let(:banned_user) { FactoryGirl.create(:banned_user) }

    before(:each) { session[:user_id] = banned_user.id }

    describe "get new" do
      before(:each) { get :new }

      it_should_behave_like "restricted area"
    end

    describe "post create" do
      before(:each) { post :create }

      it_should_behave_like "restricted area"
    end

    describe "patch update" do
      before(:each) { patch :update, id: reaction.id }

      it_should_behave_like "restricted area"
    end

    describe "get edit" do
      before(:each) { get :edit, id: reaction.id }

      it_should_behave_like "restricted area"
    end

    describe "get index" do
      before(:each) { get :index }

      it_should_behave_like "restricted area"
    end

    it_should_behave_like "viewable reaction page"
  end
end
