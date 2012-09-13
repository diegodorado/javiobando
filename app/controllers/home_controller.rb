class HomeController < ApplicationController
  def index
    @first_article = Portada.where('draft=?', false).first
    @articles = Personal.where('draft=?', false)
  end
  def comercial
    @articles = Comercial.where('draft=?', false)
  end  
end
