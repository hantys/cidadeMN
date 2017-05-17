Rails.application.routes.draw do
  devise_for :users
  resources :causes do
    get :my_causes, on: :collection
  end
  resources :categories, only: [:index]

  get '/show_causa/:id' => 'causes#show_cause'
  get '/find_causes' => 'causes#find_causes'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
