Rails.application.routes.draw do
  # devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}
  devise_for :users, path: "auth", :controllers =>
  {
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  get '/auth/:provider/callback',    to: 'users#create',       as: :auth_callback
  get '/auth/failure',               to: 'users#auth_failure', as: :auth_failure
  root 'band_bulletin_boards#home'
  post "/" => "microposts#index"
  get  '/help',    to: 'band_bulletin_boards#help'
  get  '/about',   to: 'band_bulletin_boards#about'
  get  '/contact', to: 'contacts#new'
  post '/contact/create', to: 'contacts#create'
  get  '/signup', to: 'users#new'
  get  '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/new', to: 'microposts#new'
  get '/micropost/search/:per/', to: 'microposts#microposts_list_page', as: 'list_page'
  # post '/micropost/:micropost_id/update', to: 'microposts#update'
  get  '/micropost/search', to: 'microposts#search'
  post '/micropost/search', to: 'microposts#search'
  get  '/user/search', to: 'users#search'
  post '/user/search', to: 'users#search'
  get  '/recruitment', to: 'microposts#recruitment'
  get  '/join', to: 'users#join'
  post '/like/:micropost_id' => 'likes#create', as: 'like'
  delete '/like/:micropost_id' => 'likes#destroy', as: 'unlike'
  get '/notification', to: 'notifications#index'
  delete '/notification/delete', to: 'notifications#destroy'
  get 'users/:user_id/passwords/edit', to: 'users#password_edit', as: 'password_edit'
  put 'users/:user_id/passwords/update', to: 'users#password_update', as: 'password_update'

  resources :users do
    # resources  :passwords,           only: [:edit, :update]
    member do
    end
  end

  resources :users do
    collection do
      delete 'destroy_all'
    end
  end

  resources :microposts do
    resources :likes
    resources :comments
  end

  resources :users
  resources :microposts, only: [:edit]
  resources :users, only: [:edit]
  resources :account_activations, only: [:edit]
  # resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :relationships,       only: [:create, :destroy]
  resources :notifications
end
