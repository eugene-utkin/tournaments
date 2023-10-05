Rails.application.routes.draw do
  root to: 'tournaments#index'
  resources :tournaments
end
