Rails.application.routes.draw do
  root 'top#index'
  devise_for :users
  resources :users, only: [:show]
  resources :foods

  get "/terms", to: "static_pages#terms", as: "terms"
  get "/privacy", to: "static_pages#privacy", as: "privacy"
  get "/contact", to: "static_pages#contact", as: "contact"
end
