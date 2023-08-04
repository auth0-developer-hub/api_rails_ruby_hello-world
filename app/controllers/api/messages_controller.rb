# frozen_string_literal: true

module Api
  class MessagesController < BaseController
    before_action :authorize, except: [:public]

    def admin
      validate_permissions ['read:admin-messages'] do
        render json: Message.admin_message
      end
    end

    def protected
      render json: Message.protected_message
    end

    def public
      render json: Message.public_message
    end
  end
end
