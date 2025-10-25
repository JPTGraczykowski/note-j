class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :load_sidebar_data

  private

  def load_sidebar_data
    return unless current_user

    @all_folders = current_user.folders.order(:name).to_a
  end

  def current_user
    # Placeholder for authentication - will be implemented when we add authentication
    @current_user ||= User.first || User.create!(
      name: "Demo User",
      email: "demo@example.com",
      provider: "demo",
      uid: "demo123"
    )
  end

  helper_method :current_user
end
