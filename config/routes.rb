Rails.application.routes.draw do
  # devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}
devise_for :users, path: "auth", :controllers =>
{sessions: 'sessions', registrations: 'registrations', confirmations: 'confirmations', passwords: 'passwords',
  omniauth_callbacks: 'users/omniauth_callbacks'}
  # devise_for :users, :controllers => {
   #  :registrations => 'users/registrations',
   #  :sessions => 'users/sessions',
   #  :passwords => 'users/passwords',
   # }
  get '/auth/:provider/callback',    to: 'users#create',       as: :auth_callback
  get '/auth/failure',               to: 'users#auth_failure', as: :auth_failure

  root 'insta_clones#home'
  post "/" => "microposts#index"
  get  '/help',    to: 'insta_clones#help'
  get  '/about',   to: 'insta_clones#about'
  get  '/contact', to: 'insta_clones#contact'
  get  '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get   "/new" ,     to:"microposts#new"
  post   '/like/:micropost_id' => 'likes#create',   as: 'like'
  delete '/like/:micropost_id' => 'likes#destroy', as: 'unlike'
  get '/notifications',to:'notifications#index'
  get 'users/:user_id/passwords/edit',to:'passwords#edit'
  get 'users/:user_id/passwords/update',to:'passwords#update'

  resources :users do
    resources  :passwords,           only: [:edit, :update]
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
  resources :account_activations, only: [:edit]
  # resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :relationships,       only: [:create, :destroy]
  resources :notifications
  resources  :passwords,           only: [:edit, :update]
end
