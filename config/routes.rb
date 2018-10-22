Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs do
    post 'toggle_confirmed', on: :member
  end  
  resources :users do
    post 'toggle_activity', on: :member
  end
  resources :beers
  resources :styles
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  root 'breweries#index'
  get 'kaikki_bisset', to: 'beers#index'
  resources :ratings, only: [:index, :new, :create, :destroy]
  get 'signup', to: 'users#new'
  resource :session, only: [:new, :create, :destroy]
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  get 'places', to:'places#index'
  get 'places/:id', to:'places#show'
  post 'places', to:'places#search'
  get 'beerlist', to:'beers#list'
  get 'brewerylist', to:'breweries#list'
end
