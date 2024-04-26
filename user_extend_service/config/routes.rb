Rails.application.routes.draw do
  get "find", to: 'users#find'
  get "users/document", to: 'users#find_block'
  get "users/log", to: 'users#find_log'
  post "users", to: 'users#create' 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
