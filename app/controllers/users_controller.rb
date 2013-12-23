class UsersController < ApplicationController
  # get /users/new
  def new
  end

  # post /users
  def create
    init_invite
    if invite_is_good
      create_user
    else
      flash[:message] = t('users.create.bad_code')
      render action: 'new'
    end
  end

  private

  def creation_parameters
    params.require(:user).permit([:login, :password, :password_confirmation])
  end

  def init_invite
    @invite = Invite.find_by_code(params[:code])
  end

  def activate_invite
    @invite.activate!(@user) if invite_is_good
  end

  def invite_is_good
    !@invite.nil? && @invite.usable?
  end

  def create_user
    @user = User.new(creation_parameters)
    if @user.save
      post_create_actions
    else
      render action: 'new'
    end
  end

  def post_create_actions
    session[:user_id] = @user.id
    activate_invite
    flash[:message] = t('users.create.success')
    redirect_to root_path
  end
end
