Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks"}
  post 'bikes/create'

  root 'welcome#index'

  resources :account, only: [:index, :update, :destroy]

end
