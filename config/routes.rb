Rails.application.routes.draw do
  resources :users
  post '/auth/login', to: 'authentication#login'

  resources :tickets, only: %i[index show create update destroy] do
    collection do
      get 'search'
    end
  end
end
