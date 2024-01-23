Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, only: [:index, :destroy] do
    collection do
      get 'search'
      get "daily_records"
    end
  end

  root 'users#index'
end
