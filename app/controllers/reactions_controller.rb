class ReactionsController < ApplicationController
  before_action :restrict_access, except: [:show]
  before_action :set_reaction, only: [:show, :update, :edit, :destroy]

  # get /reactions
  def index
    page = params[:page] || 1

    @reactions = Reaction.order('id desc').page(page).per(20)
  end

  # post /reactions
  def create
    @reaction = Reaction.new(creation_parameters)
    if @reaction.save
      flash[:message] = 'Реакция добавлена'
      redirect_to @reaction
    end
  end

  # patch /reactions/:id
  def update
    if @reaction.update(update_parameters)
      flash[:notice] = 'Реакция обновлена'
      redirect_to @reaction
    end
  end

  # delete /reactions/:id
  def destroy
    if @reaction.destroy
      flash[:notice] = 'Реакция удалена'
      redirect_to root_path
    end
  end

protected
  def creation_parameters
    params.require(:reaction).permit(:title, :image).merge(user: current_user)
  end

  def update_parameters
    params.require(:reaction).permit(:title)
  end

  def set_reaction
    @reaction = Reaction.find params[:id]
  end

  def restrict_access
    if current_user.nil?
      flash[:notice] = 'Необходима авторизация'
      redirect_to login_path
    end
  end
end
