Rails.application.routes.draw do
  root 'top#index'
  devise_for :users, controller: {
    registrations: 'users/registrations'
  }
  resources :users, only: [:show]
  resources :foods
  resources :notifications, only: [:index] do
    collection do
      delete :destroy_all
    end
  end

  get "/terms", to: "static_pages#terms", as: "terms"
  get "/privacy", to: "static_pages#privacy", as: "privacy"
  get "/contact", to: "static_pages#contact", as: "contact"

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in', as: 'guest_sign_in'
  end
end
