# frozen_string_literal: true

module Api
  # Controller to fetch messages from the server
  class MessagesController < BaseController
    PUBLIC_MESSAGE = 'The starter API doesn\'t require an access token to share this public message.'
    PROTECTED_MESSAGE = 'The starter API doesn\'t require an access token to share this protected message.'
    ADMIN_MESSAGE = 'The starter API doesn\'t require an access token to share this admin message.'
    API_NAME = 'api_rails_ruby_hello-world'
    API_BRANCH = 'starter'

    def public
      render json: {
        text: PUBLIC_MESSAGE,
        api: API_NAME,
        branch: API_BRANCH
      }
    end

    def protected
      render json: {
        text: PROTECTED_MESSAGE,
        api: API_NAME,
        branch: API_BRANCH
      }
    end

    def admin
      render json: {
        text: ADMIN_MESSAGE,
        api: API_NAME,
        branch: API_BRANCH
      }
    end
  end
end
