require 'spec_helper'

describe SessionsController do
  context 'Anonymous user' do
    describe 'get new' do
      it 'renders view with form' do
        get :new
        response.should render_template('sessions/new')
      end
    end

    describe 'post create' do
      it 'redirects to root page with valid credentials'
      it 'redirects to login form with invalid credentials'
    end

    describe 'delete destroy' do
      it 'redirects to root page'
      it 'adds flash message "already unauthorized"'
    end
  end

  context 'Successful login' do
    it 'creates session with user id'
    it 'adds flash message "logged in successfully"'
  end

  context 'Authorized user' do
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
