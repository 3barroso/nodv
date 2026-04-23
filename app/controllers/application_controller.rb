class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

    # making more than one role requirement ? create Authorization Concern and include here
    def require_admin
      unless current_user&.admin?
        redirect_to root_path, alert: "Access denied. Admins only."
      end
    end

    # current user is authorized to edit resource because they created it?
    # similar to `ensure_author_access` and `manageable_by?(current_user)` in author.rb

    def record_not_found(exception)
      redirect_to root_path, alert: "We could not find what you were looking for, it does not exist."
    end
end
