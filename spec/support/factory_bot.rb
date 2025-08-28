# frozen_string_literal: true

# Factory Bot configuration for RSpec
RSpec.configure do |config|
  # Include Factory Bot methods in all specs
  config.include FactoryBot::Syntax::Methods

  # Lint factories to ensure they're valid
  config.before(:suite) do
    FactoryBot.lint
  rescue FactoryBot::InvalidFactoryError => e
    # Only fail if we have factories to lint
    raise e if Dir.glob(Rails.root.join("spec/factories/**/*.rb")).any?
  end
end
