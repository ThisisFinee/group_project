Rails.application.routes.draw do
    get 'tickets/free'

    get 'tickets/status', to: 'tickets#update'

    get 'tickets/block'

    get 'tickets', to: 'tickets#show'
    
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
