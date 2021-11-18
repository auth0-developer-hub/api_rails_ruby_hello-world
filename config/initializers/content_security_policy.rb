# frozen_string_literal: true

Rails.application.config.content_security_policy do |policy|
  policy.default_src :self
  policy.frame_ancestors :none
end
