class ReactionsController < ApplicationController
  before_action :set_reaction, only: [:show, :update]

  # get /reactions/new
  def new
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
  end

  # patch /reactions/:id
  def update
    if @reaction.update(update_parameters)
      redirect_to @reaction
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
end
