Rails.application.routes.draw do

  root 'rates#index'

  get '/rates', to: 'rates#index'

  get '/rate/usdclp', to: 'rates#last_usdclp'
  get '/rate/gbpclp', to: 'rates#last_gbpclp'
  get '/rate/eurclp', to: 'rates#last_eurclp'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
