Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resource :assertion, only: [:create, :destroy]
  post "/assertions/consume" => "assertions#create", as: :consume
  post "/assertions/logout" => "assertions#destroy", as: :logout
  resource :metadata, only: [:show]
  resources :service_providers, only: [:show, :new, :create, :destroy]
  resources :identity_providers, only: [:show, :new, :create, :update, :destroy]
  resources :providers, only: [:index]
  root to: "providers#index"
end
