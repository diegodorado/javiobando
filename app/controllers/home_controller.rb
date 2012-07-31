class HomeController < ApplicationController
  def index
    @first_article = Article.where('section=?', :po).first
    @articles = Article.where('section=?', :pe).order('created_at DESC')
  end
  def comercial
    @articles = Article.where('section=?', :co).order('created_at DESC')
  end  
end
