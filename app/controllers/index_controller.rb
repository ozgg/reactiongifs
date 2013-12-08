class IndexController < ApplicationController
  def index
    page   = params[:page] || 1
    @title = "Реакции в GIF-картинках, страница #{page}"

    @reactions = Reaction.order('id desc').page(page).per(5)
  end
end
