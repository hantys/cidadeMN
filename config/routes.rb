Rails.application.routes.draw do
  devise_for :users
  resources :causes
  resources :categories

  get '/show_causa/:id' => 'causes#show_cause'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
