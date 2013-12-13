require 'spec_helper'

describe ReactionsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:reaction_parameters) { FactoryGirl.attributes_for(:reaction) }
  let(:reaction) { FactoryGirl.create(:reaction, user: user) }
  let!(:approved_reaction) { FactoryGirl.create(:approved_reaction, user: user) }

  shared_examples "restricted area" do
    it "redirects to login page" do
      expect(response).to redirect_to(login_path)
    end

    it "adds flash message 'Недостаточно прав'" do
      expect(flash[:notice]).to eq(I18n.t('authorization.insufficient_rights'))
    end
  end

  shared_examples "restricted any unapproved reaction page" do
    describe "get show" do
      before(:each) { get :show, id: reaction }

      it_should_behave_like "restricted area"
    end
  end

  shared_examples "restricted others unapproved reaction page" do
    let(:other_guy) { FactoryGirl.create(:user, login: 'another_guy') }
    let(:other_reaction) { FactoryGirl.create(:reaction, user: other_guy) }

    describe "get show" do
      before(:each) { get :show, id: other_reaction }

      it_should_behave_like "restricted area"
    end
  end

  shared_examples "restricted editing" do
    describe "get index" do
      before(:each) { get :index }

      it_should_behave_like "restricted area"
    end

    describe "get edit" do
      before(:each) { get :edit, id: reaction.id }

      it_should_behave_like "restricted area"
    end

    describe "patch update" do
      before(:each) { patch :update, id: reaction.id }

      it_should_behave_like "restricted area"
    end

    describe "delete destroy" do
      before(:each) { delete :destroy, id: reaction }

      it_should_behave_like "restricted area"
    end
  end

  shared_examples "restricted management" do
    it_should_behave_like "restricted editing"

    describe "get new" do
      before(:each) { get :new }

      it_should_behave_like "restricted area"
    end

    describe "post create" do
      before(:each) { post :create }

      it_should_behave_like "restricted area"
    end
  end

  shared_examples "reaction view renderer" do
    it "renders view with reaction" do
      expect(response).to render_template('reactions/show')
    end
  end

  shared_examples "viewable approved reaction page" do
    describe "get show" do
      before(:each) { get :show, id: approved_reaction.id }

      it_should_behave_like "reaction view renderer"

      it "assigns @reaction" do
        expect(assigns[:reaction]).to eq(approved_reaction)
      end
    end
  end

  context "User is not logged in" do
    before(:each) { session[:user_id] = nil }

    it_should_behave_like "restricted management"
    it_should_behave_like "viewable approved reaction page"
    it_should_behave_like "restricted any unapproved reaction page"
  end

  context "Banned user is logged in" do
    before(:each) { session[:user_id] = FactoryGirl.create(:banned_user).id }

    it_should_behave_like "restricted management"
    it_should_behave_like "viewable approved reaction page"
    it_should_behave_like "restricted any unapproved reaction page"
  end

  context "Active user is logged in" do
    before(:each) { session[:user_id] = user.id }

    it_should_behave_like "restricted editing"
    it_should_behave_like "viewable approved reaction page"
    it_should_behave_like "restricted others unapproved reaction page"

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

    describe "get show for own unapproved reaction" do
      let(:another_reaction) { FactoryGirl.create(:reaction, user: user) }

      before(:each) { get :show, id: another_reaction }

      it_should_behave_like "reaction view renderer"

      it "assigns @reaction" do
        expect(assigns[:reaction]).to eq(another_reaction)
      end
    end
  end

  context "Trusted user is logged in" do
    let(:trusted_user) { FactoryGirl.create(:trusted_user) }
    before(:each) { session[:user_id] = trusted_user.id }

    it_should_behave_like "restricted editing"
    it_should_behave_like "viewable approved reaction page"
    it_should_behave_like "restricted others unapproved reaction page"

    describe "post create" do
      it "adds approved reaction" do
        post :create, reaction: reaction_parameters
        expect(Reaction.last).to be_approved
      end
    end

    describe "get show for own unapproved reaction" do
      let(:another_reaction) { FactoryGirl.create(:reaction, user: trusted_user) }

      before(:each) { get :show, id: another_reaction }

      it_should_behave_like "reaction view renderer"

      it "assigns @reaction" do
        expect(assigns[:reaction]).to eq(another_reaction)
      end
    end
  end

  context "Moderator is logged in" do
    let(:moderator) { FactoryGirl.create(:moderator) }

    before(:each) { session[:user_id] = moderator.id }

    it_should_behave_like "viewable approved reaction page"

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

      it "sets approval flag" do
        patch :update, id: reaction, reaction: { approved: true }
        reaction.reload
        expect(reaction.approved?).to be_true
      end

      it "unsets approval flag" do
        patch :update, id: approved_reaction, reaction: { approved: false }
        approved_reaction.reload
        expect(approved_reaction.approved?).to be_false
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

    describe "get show for own unapproved reaction" do
      let(:another_reaction) { FactoryGirl.create(:reaction, user: moderator) }

      before(:each) { get :show, id: another_reaction }

      it_should_behave_like "reaction view renderer"

      it "assigns @reaction" do
        expect(assigns[:reaction]).to eq(another_reaction)
      end
    end

    describe "get show for unapproved reaction" do
      before(:each) { get :show, id: reaction }

      it_should_behave_like "reaction view renderer"

      it "assigns @reaction" do
        expect(assigns[:reaction]).to eq(reaction)
      end
    end
  end
end
