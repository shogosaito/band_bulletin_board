Rails.application.routes.draw do
  # devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}
  devise_for :users, path: "auth", :controllers =>
  {
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  get '/auth/:provider/callback',    to: 'users#create',       as: :auth_callback
  get '/auth/failure',               to: 'users#auth_failure', as: :auth_failure
  root 'insta_clones#home'
  post "/" => "microposts#index"
  get  '/help',    to: 'insta_clones#help'
  get  '/about',   to: 'insta_clones#about'
  get  '/contact', to: 'contacts#new'
  post '/contact/create', to: 'contacts#create'
  get  '/signup',  to: 'users#new'
  get  '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get  '/new', to: 'microposts#new'
  # post '/micropost/:micropost_id/update', to: 'microposts#update'
  get  '/search', to: 'microposts#search'
  post '/search', to: 'microposts#search'
  get  '/user/search', to: 'users#search'
  post '/user/search', to: 'users#search'
  get  '/recruitment', to: 'microposts#recruitment'
  get  '/join', to: 'users#join'
  post  '/like/:micropost_id' => 'likes#create', as: 'like'
  delete '/like/:micropost_id' => 'likes#destroy', as: 'unlike'
  get '/notifications', to: 'notifications#index'
  get 'users/:user_id/passwords/edit', to: 'passwords#edit'
  get 'users/:user_id/passwords/update', to: 'passwords#update'

  resources :users do
    # resources  :passwords,           only: [:edit, :update]
    member do
      get :following, :followers
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
  resources :passwords, only: [:edit, :update]
end
