Rails.application.routes.draw do


  root "home#index"

  # Routes for the home controller
  get 'home/contact'
  get 'home/index'
  get 'home/about'
  get 'home/faq'
  get 'home/custom_report'
  get 'home/activity_sheet'
  post '/report' => "home#custom_report"
  get '/dispose_item/:id' => "home#dispose_item"
  get '/pharmacy_sheet/:date' => "home#activity_sheet"
  get '/provider_suggestions' => "home#provider_suggestions"
  get '/drug_name_suggestions' => "home#drug_name_suggestions"

  # Routes for the sessions controller

  get 'sessions/new'
  get 'sessions/destroy'
  post 'sessions/create'
  get "/login" => "sessions#new"
  get "/logout" => "sessions#destroy"

  # Routes for the general inventory 
  get "general_inventories/print/:id" => "general_inventories#print"
  get "/void_general_inventory/:id" => "general_inventories#delete", as: 'void_general_inventory'
  post "/delete_general_inventory_item/:id" => "general_inventories#destroy"


  # Routes for the pmap inventory 
  get "/reorders" => "pmap_inventories#reorders"
  get "pmap_inventories/print/:id" => "pmap_inventories#print"
  get "/move_pmap_inventory/:id" => "pmap_inventories#move_inventory"
  post "/delete_pmap_inventory_item/:id" => "pmap_inventories#destroy"
  get "/void_pmap_inventory/:id" => "pmap_inventories#delete", as: 'void_pmap_inventory'


  # Routes for prescriptions
  get "void_prescription/:id" => "prescriptions#void_prescription", as: 'void_prescription'
  get "ajax_prescriptions" => "prescriptions#ajax_prescriptions"
  get "dashboard" => "prescriptions#dashboard"

  # Routes for dispensaions
  get "print_dispensation_label" => "dispensations#print_dispensation_label"
  get "/refill" => "dispensations#refill"
  post "/refill" => "dispensations#refill"

  # Routes for users
  get "/new_user_role" => "users#new_user_role"
  post "users/create_user_role", as: 'create_user_role'

  # Routes for patients
  post "/update_language/:id" => "patients#update_language"


  # Routes for manufacturers
  post "/toggle_pmap/:id" => "manufacturers#toggle_pmap"
  get "/void_manufacturer/:id" => "manufacturers#delete", as: 'void_manufacturer'


  # Routes for news
  get "/void_news_item/:id" => "news#delete", as: 'void_news'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :news
  resources :users
  resources :patients
  resources :prescriptions
  resources :dispensations
  resources :manufacturers
  resources :pmap_inventories
  resources :general_inventories
end
