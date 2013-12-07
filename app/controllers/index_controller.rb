class IndexController < ApplicationController
  def index
    @reactions = Reaction.order('id desc').page(params[:page] || 1).per(5)
  end
end
