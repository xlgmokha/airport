Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resource :assertion, only: [:create, :destroy]
  post "/assertions/consume" => "assertions#create", as: :consume
  post "/assertions/logout" => "assertions#destroy", as: :logout
  resource :metadata, only: [:show]
  resources :service_providers, except: [:edit, :update]
  resources :identity_providers, except: [:edit]
  root to: "identity_providers#index"
end
