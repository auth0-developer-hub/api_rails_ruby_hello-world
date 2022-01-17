# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
<<<<<<< HEAD
    include Authorizable
=======
    after_action :security_headers
>>>>>>> 9306f36 (Update HTTP headers)

    rescue_from StandardError do |e|
      render json: { message: e.message }, status: :internal_server_error
    end

    def security_headers
      response.headers.merge!(
        {
          'X-Frame-Options' => 'deny',
          'X-XSS-Protection' => '0',
          'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains',
          'X-Content-Type-Options' => 'nosniff',
          'Cache-Control' => 'no-store',
          'Pragma' => 'no-cache',
          'Content-Security-Policy' => "default-src 'self', frame-ancestors 'none'"
        }
      )
    end
  end
end
