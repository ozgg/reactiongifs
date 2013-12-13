class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

protected
  def current_user
    unless session[:user_id].nil?
      User.find session[:user_id]
    end
  end

  def moderator?
    user = current_user
    !user.nil? && user.moderator?
  end
end
