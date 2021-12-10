# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch 'CLIENT_ORIGIN_URL'

    resource '*',
             headers: %w[Authorization Content-Type],
             methods: [:get],
             max_age: 86_400
  end
end
