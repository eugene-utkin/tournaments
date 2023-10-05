Rails.application.routes.draw do
  root to: 'tournaments#index'
  resources :tournaments do
    post :create_random_teams, on: :member
    post :create_matches, on: :member
  end
end
