Rails.application.routes.draw do
  resources :in_out_events
  post '/pass', to: 'gate#pass'
end
