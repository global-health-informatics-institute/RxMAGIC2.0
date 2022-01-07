Rails.application.routes.draw do


  root "home#index"

  # Routes for the home controller
  get 'home/contact'
  get 'home/index'
  get 'home/about'
  get 'home/faq'

  # Routes for the sessions controller

  get 'sessions/new'
  get 'sessions/destroy'
  post 'sessions/create'
  get "/login" => "sessions#new"
  delete "/logout" => "sessions#destroy"

  # Routes for the general inventory 
  get "print_bottle_barcode/:id" => "general_inventories#print"
  get "void_item/:id" => "general_inventories#delete"


  # Routes for prescriptions
  get "void_prescription/:id" => "prescriptions#void_prescription", as: 'void_prescription'
  get "ajax_prescriptions" => "prescriptions#ajax_prescriptions"
  get "dashboard" => "prescriptions#dashboard"

  # Routes for dispensaions
  get "print_dispensation_label" => "dispensations#print_dispensation_label"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  resources :patients
  resources :prescriptions
  resources :dispensations
  resources :general_inventories
end
