Rails.application.routes.draw do
  devise_for :users
  root 'pages#index'
  get 'pages/show'
  get 'pages/ring_select_for_check'
  get 'pages/check_front'

  get 'cards/front'
  get 'cards/front_save'
  get 'cards/back'
  get 'cards/back_save'

  get 'rings/search'

  get 'check_logs/index'
  get 'check_logs/search'

  resources :cards, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    member do
      get :add_to_ring
      get :remove_from_ring
    end
  end
  
  resources :rings, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :card_ring_links, only: [:create, :destroy]

  resources :card_ring_links, only: [:create, :destroy]
end
