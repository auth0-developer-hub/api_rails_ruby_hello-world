# frozen_string_literal: true

module Api
  # Controller to fetch messages from the server
  class MessagesController < BaseController
    before_action :authorize, except: %i[public]

    def public
      api_response(Message.public_message.as_json)
    end

    def protected
      api_response(Message.protected_message.as_json)
    end

    def admin
      api_response(Message.admin_message.as_json)
    end

    private

    def api_response(message_hash)
      metadata = {
        api: 'api_rails_ruby_hello-world',
        branch: 'basic-authorization'
      }
      message_hash[:metadata] = metadata
      render json: message_hash
    end
  end
end
