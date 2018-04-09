Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      resources :friendships, only: :create
      get 'friends', to: 'friendships#user_friends'
      get 'mutual_friends', to: 'friendships#mutual_friends'
      resources :subscriptions, only: :create
      get 'recipients', to: 'subscriptions#recipients'
      post 'block_user', to: 'blocked_users#create'
    end
  end
end
