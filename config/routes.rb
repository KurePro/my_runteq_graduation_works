Rails.application.routes.draw do
  get "foods/index"
  devise_for :users
  
  root 'top#index'

  get "/terms", to: "static_pages#terms", as: "terms"
  get "/privacy", to: "static_pages#privacy", as: "privacy"
  get "/contact", to: "static_pages#contact", as: "contact"
end
