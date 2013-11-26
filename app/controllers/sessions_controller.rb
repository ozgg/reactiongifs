class SessionsController < ApplicationController

  # get /login
  def new
  end

  # post /login
  def create
    user = User.find_by_login params[:login]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = 'session.logged_in_successfully'
    end
    redirect_to root_path
  end

  # delete /logout
  def destroy
    if session[:user_id].nil?
      flash[:notice] = 'session.not_logged_in'
    end
    redirect_to root_path
  end
end