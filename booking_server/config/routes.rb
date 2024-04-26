Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  
  get '/booking/show', to: 'booking#show'

  post '/booking', to: 'booking#create'
  
  post '/booking/check_tickets_availability', to: 'booking#check_tickets_availability'

  delete '/booking/cancel', to: 'booking#cancel'

  delete '/booking', to: 'booking#delete'
  
end
