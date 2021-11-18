# frozen_string_literal: true

# Controller that renders custom errors
class ErrorsController < ApplicationController
  def not_found
    render json: { message: 'Not Found' }, status: :not_found
  end
end
