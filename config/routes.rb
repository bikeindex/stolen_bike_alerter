Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks"}

  resources :bikes, only: [:create]

  root 'welcome#index'

  resources :twitter_accounts, only: [:show, :update, :index, :destroy]

end
