# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resource :messages, only: [] do
      get 'protected'
      get 'public'
      get 'admin'
    end
  end
  match '/404', to: 'api/errors#not_found', via: :all
end
