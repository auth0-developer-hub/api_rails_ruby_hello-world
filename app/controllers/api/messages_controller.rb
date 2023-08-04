# frozen_string_literal: true

module Api
  class MessagesController < BaseController
    def admin
      render json: Message.admin_message
    end

    def protected
      render json: Message.protected_message
    end

    def public
      render json: Message.public_message
    end
  end
end
