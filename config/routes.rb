Rails.application.routes.draw do
  resources :sales
  resources :categories
  resources :products
  resources :sellers
  resources :buyers
  root to: 'page#index'
  get '/newbuyer', to: 'buyers#new'
  get '/newseller', to: 'sellers#new'
  get '/login', to: 'session#new'
  post '/login', to: 'session#create'
  get '/logout', to: 'session#destroy'
  get '/dashboard', to: 'page#admin'
  get '/forbidden', to: 'page#403'
  get '/about',  to:'page#about'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
