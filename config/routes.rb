Rails.application.routes.draw do
  get "work/index"
  get "about/index"
  resources :articles
  root "home#index"
end
