Rails.application.routes.draw do
  resources :posts
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'destroy_all' ,to: 'users#destroy_all'
  get 'main' ,to: 'main#login'
  post 'login' ,to: 'users#login'
  get "feed/:id" ,to: "users#feed"
  get "profile/:name" ,to:"users#profile"
  get "/updateprofile/:name" ,to: "users#profileUpdate"
  get "/like/:postID" ,to: "users#likeUpdate"
  post "setFollow" , to: "users#profileUpdate"
  post "setLike" , to:"users#likeUpdate"
end
