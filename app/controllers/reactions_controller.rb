class ReactionsController < ApplicationController

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

protected
  def creation_parameters
    params.require(:reaction).permit(:title, :image).merge(user: current_user)
  end

end
