require "sidekiq/web"

Rails.application.routes.draw do
  resources :tasks, only: [:new, :create]
  root "tasks#new"
end
