require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  resources :tasks, only: [:new, :create] do
    resources :profit_pairs, only: :index
  end
  root "tasks#new"
end
