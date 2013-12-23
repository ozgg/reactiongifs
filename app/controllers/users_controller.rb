class UsersController < ApplicationController
  # get /users/new
  def new
  end

  # post /users
  def create
    check_invite
    @user = User.new(creation_parameters)
    @user.save
    session[:user_id] = @user.id
    activate_invite
    flash[:message] = t('users.create.success')
    redirect_to root_path
  end

  private

  def creation_parameters
    params.require(:user).permit([:login, :password, :password_confirmation])
  end

  def check_invite
    @invite = Invite.find_by_code(params[:code])
  end

  def activate_invite
    unless @invite.nil? || !@invite.usable?
      @invite.activate!(@user)
    end
  end
end
