Rails.application.routes.draw do

  root "home#index"

  # Routes for the home controller
  get 'home/contact'
  get 'home/index'
  get 'home/about'
  get 'home/faq'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
