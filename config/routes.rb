require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/side"

  resources :tasks, only: [:new, :create]
  root "tasks#new"
end
