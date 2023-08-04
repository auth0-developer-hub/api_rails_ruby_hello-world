# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch('CLIENT_ORIGIN_URL', nil)

    resource '*',
             headers: %w[Authorization Content-Type],
             methods: [:get],
             max_age: 86_400
  end
end
