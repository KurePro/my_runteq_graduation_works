Rails.application.routes.draw do
  get "users/show"
  devise_for :users
  
  root 'top#index'

  resources :foods

  get "/terms", to: "static_pages#terms", as: "terms"
  get "/privacy", to: "static_pages#privacy", as: "privacy"
  get "/contact", to: "static_pages#contact", as: "contact"
end
