# Factory Bot configuration
if defined?(FactoryBot)
  FactoryBot.define do
    to_create(&:save!)
  end
end
