# frozen_string_literal: true

# Factory Bot configuration
if defined?(FactoryBot)
  FactoryBot.define do
    # Set default strategy
    to_create(&:save!)
  end
end
