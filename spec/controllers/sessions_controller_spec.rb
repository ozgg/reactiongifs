require 'spec_helper'

describe SessionsController do

  let(:user) { User.create! login: 'random_guy', password: 'secret', password_confirmation: 'secret' }

  context 'when user is not logged in' do
    before :each do
      session[:user_id] = nil
    end

    describe 'get new' do
      it 'renders view with form' do
        get :new
        response.should render_template('sessions/new')
      end
    end

    describe 'delete destroy' do
      it 'redirects to root page' do
        delete :destroy
        response.should redirect_to(root_path)
      end

      it 'adds flash notice "session.not_logged_in"' do
        delete :destroy
        flash[:notice].should eq('session.not_logged_in')
      end
    end
  end

  context 'Successful login' do
    before :each do
      post :create, login: user.login, password: 'secret'
    end

    it 'creates session with user id' do
      session[:user_id].should eq(user.id)
    end

    it 'redirects to root page' do
      response.should redirect_to(root_path)
    end

    it 'adds flash notice "session.logged_in_successfully"' do
      flash[:notice].should eq('session.logged_in_successfully')
    end
  end

  context 'Unsuccessful login' do
    before :each do
      post :create, login: user.login, password: 'incorrect'
    end

    it 'redirects to login page' do
      response.should redirect_to(login_path)
    end

    it 'adds flash notice "session.invalid_credentials"' do
      flash[:notice].should eq('session.invalid_credentials')
    end
  end

  context 'when user is logged in' do
    before :each do
      session[:user_id] = user.id
    end

    describe 'get new' do
      before :each do
        get :new
      end

      it 'redirects to root page' do
        response.should redirect_to(root_path)
      end

      it 'adds flash notice "session.already_logged_in"' do
        flash[:notice].should eq('session.already_logged_in')
      end
    end

    describe 'post create' do
      before :each do
        post :create
      end

      it 'redirects to root page' do
        response.should redirect_to(root_path)
      end

      it 'adds flash notice "session.already_logged_in"' do
        flash[:notice].should eq('session.already_logged_in')
      end
    end

    describe 'delete destroy' do
      before :each do
        delete :destroy
      end

      it 'deletes user id from session' do
        session[:user_id].should be_nil
      end

      it 'redirects to root page' do
        response.should redirect_to(root_path)
      end

      it 'adds flash notice "session.logged_out"' do
        flash[:notice].should eq('session.logged_out')
      end
    end
  end
end
