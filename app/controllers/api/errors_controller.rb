# frozen_string_literal: true

module Api
  class ErrorsController < ApplicationController
    def not_found
      render json: { message: 'Not Found' }, status: :not_found
    end
  end
end
