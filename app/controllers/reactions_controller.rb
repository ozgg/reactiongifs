class ReactionsController < ApplicationController
  before_action :restrict_access, except: [:show]
  before_action :allow_only_moderators, except: [:show, :new, :create]
  before_action :set_reaction, only: [:show, :update, :edit, :destroy]

  # get /reactions
  def index
    page   = params[:page] || 1
    @title = "Реакции, страница #{page}"

    @reactions = Reaction.order('id desc').page(page).per(20)
  end

  # get /reactions/pending
  def pending
    page   = params[:page] || 1
    @title = "#{t('title.pending_reactions')}, #{t('page')} #{page}"

    @reactions = Reaction.where(:approved => false).page(page).per(20)
  end

  # get /reactions/new
  def new
    @title = 'Добавить реакцию'
  end

  # post /reactions
  def create
    @reaction = Reaction.new(creation_parameters)
    if @reaction.save
      flash[:message] = 'Реакция добавлена'
      redirect_to @reaction
    end
  end

  # get /reactions/:id
  def show
    redirect_with_notice unless @reaction.approved || my_reaction? || moderator?
    @title = @reaction.title
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
    user     = current_user
    to_merge = {
        user: user,
        approved: user.trusted?
    }
    params.require(:reaction).permit(:title, :image).merge(to_merge)
  end

  def update_parameters
    params.require(:reaction).permit(:title, :approved)
  end

  def set_reaction
    @reaction = Reaction.find params[:id]
  end

  def restrict_access
    redirect_with_notice if current_user.nil? || !current_user.can_post?
  end

  def allow_only_moderators
    redirect_with_notice unless moderator?
  end

  def redirect_with_notice
    flash[:notice] = t('authorization.insufficient_rights')
    redirect_to login_path
  end

  def my_reaction?
    @reaction.user_id == session[:user_id]
  end
end
