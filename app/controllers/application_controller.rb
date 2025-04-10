class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :admin_logged_in?

  private

  def admin_logged_in?
    session[:admin_id].present?
  end
end
