Javiobando::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users
  

  root :to => 'home#index'
  match '/comercial' => 'home#comercial', :as => :comercial



end
