Javiobando::Application.routes.draw do

  root :to => 'home#index'
  match '/comercial' => 'home#comercial', :as => :comercial



end
