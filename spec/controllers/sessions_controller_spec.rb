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

      it 'adds flash message "Вы ещё не вошли"' do
        delete :destroy
        flash[:notice].should eq('Вы ещё не вошли')
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

    it 'adds flash message "Вы успешно вошли"' do
      flash[:notice].should eq('Вы успешно вошли')
    end
  end

  context 'Unsuccessful login' do
    it 'redirects to login page'
    it 'adds flash message "invalid login"'
  end

  context 'when user is logged in' do
    describe 'get new' do
      it 'redirects to root page'
      it 'adds flash message "already authorized"'
    end

    describe 'post create' do
      it 'redirects to root page'
      it 'adds flash message "already authorized"'
    end

    describe 'delete destroy' do
      it 'deletes user id from session'
      it 'redirects to root page'
      it 'adds flash message "logged out"'
    end
  end
end
