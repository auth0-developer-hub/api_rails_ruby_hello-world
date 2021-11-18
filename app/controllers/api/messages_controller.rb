# frozen_string_literal: true

module Api
  # Controller to fetch messages from the server
  class MessagesController < BaseController
    before_action :authorize, except: %i[public]

    PUBLIC_MESSAGE = 'The API doesn\'t require an access token to share this message.'
    PROTECTED_MESSAGE = 'The API successfully validated your access token.'
    ADMIN_MESSAGE = 'The API successfully recognized you as an admin.'

    def public
      render json: { text: PUBLIC_MESSAGE }
    end

    def protected
      render json: { text: PROTECTED_MESSAGE }
    end

    def admin
      render json: { text: ADMIN_MESSAGE }
    end
  end
end
