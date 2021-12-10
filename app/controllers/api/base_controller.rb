# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    include Authorizable

    rescue_from StandardError do |e|
      render json: { message: e.message }, status: :internal_server_error
    end
  end
end
