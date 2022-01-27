# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :messages, only: [:index] do
      collection do
        get 'public'
        get 'protected'
        get 'admin'
      end
    end
  end

  get '/404' => 'api/errors#not_found'
end
