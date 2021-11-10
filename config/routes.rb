Rails.application.routes.draw do
  resources :posts
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'destroy_all' ,to: 'users#destroy_all'
  get 'main' ,to: 'main#login'
  post 'login' ,to: 'users#login'
  get "feed/:id" ,to: "users#feed"
  get "profile/:name" ,to:"users#profile"
  get "/updateprofile/:name/:checkfollow" ,to: "users#profileUpdate"
end
