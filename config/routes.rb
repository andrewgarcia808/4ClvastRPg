Rails.application.routes.draw do
  resources :articles, only: [:index, :show, :create, :update, :destroy]
end
