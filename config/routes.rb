Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  resources :boards, except:[:create]
  get '/player/login', to: 'players#login'
  get '/player/:id', to: 'players#showById'
  post '/players/:player_id/boards/:name/join', to: 'boards#join'
  resources :players, except:[:show] do
    resources :boards, only:[:create,:move,:destroy] do
      member do
        post :move        
      end
    end
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
