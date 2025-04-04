Rails.application.routes.draw do
  get "about/index"
  resources :articles
  root "home#index"
end
