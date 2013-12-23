require 'spec_helper'

describe UsersController do
  let!(:invite) { FactoryGirl.create(:invite) }
  let(:user_parameters) do
    {
        user: FactoryGirl.attributes_for(:user),
        code: invite.code
    }
  end

  shared_examples "no new users and re-rendering users/new" do
    it "creates no users" do
      expect { post :create, user_parameters }.not_to change(User, :count)
    end

    it "redirects to users/new" do
      post :create, user_parameters
      expect(response).to render_template('users/new')
    end
  end

  context "rendering form" do
    describe "get new" do
      before(:each) { get :new }

      it "renders users/new view" do
        expect(response).to render_template('users/new')
      end
    end
  end

  context "successful registration" do
    describe "post create" do
      before(:each) do
        post :create, user_parameters
        invite.reload
      end

      it "creates new user" do
        expect(User.last.login).to eq(request[:user][:login])
      end

      it "assigns invitee for invite" do
        expect(User.last.login).to eq(invite.invitee.login)
      end

      it "sets user session" do
        expect(session[:user_id]).to eq(invite.invitee_id)
      end

      it "redirects to root page" do
        expect(response).to redirect_to(root_path)
      end

      it "adds flash message 'Регистрация прошла успешно'" do
        expect(flash[:notice]).to eq(I18n.t('users.create.success'))
      end
    end
  end

  context "invalid invite" do
    describe "post create" do
      before(:each) do
        invite.invitee = FactoryGirl.create(:user)
        invite.save
      end

      it "adds flash message with error" do
        post :create, user_parameters
        expect(flash[:notice]).to eq(I18n.t('users.create.bad_code'))
      end

      it_should_behave_like "no new users and re-rendering users/new"
    end
  end

  context "invalid user parameters" do
    let(:user_parameters) do
      {
          user: {
              login: '!!!',
              password: '1234',
              password_confirmation: '4321'
          },
          code: invite.code
      }
    end

    it_should_behave_like "no new users and re-rendering users/new"
  end
end
