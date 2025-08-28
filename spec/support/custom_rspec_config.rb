# frozen_string_literal: true

# Custom RSpec configuration to enforce coding standards
RSpec.configure do |config|
  # Disable let and let! to force explicit variable definition in each test
  config.around(:each) do |example|
    if example.metadata[:type] != :system
      # Check for let or let! usage in the current example
      example_source = example.metadata[:location]
      if example_source&.match?(/let[!]?\s*\(/)
        pending "This example uses let/let! which is not allowed. Define variables directly in 'it' blocks."
      end
    end
    example.run
  end

  # Disable subject usage
  config.before(:suite) do
    RSpec::Core::ExampleGroup.class_eval do
      def subject(*args)
        raise "subject is not allowed. Define variables explicitly in 'it' blocks."
      end
    end
  end

  # Prefer context over describe for test organization
  # This is just a documentation note - both work the same way in RSpec
  # but we'll use context in our specs per user preference
end
