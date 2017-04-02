Rails.application.routes.draw do


  resources :rates
  root 'rates#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
