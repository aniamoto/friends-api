Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      get  'friends', to: 'friendships#show'
      post 'friends', to: 'friendships#create'
      get  'mutual_friends', to: 'friendships#show_common'
      post 'subscriptions', to: 'subscriptions#create'
    end
  end
end
