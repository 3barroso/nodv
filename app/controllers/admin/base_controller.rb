module Admin
  class BaseController < ApplicationController
    before_action :store_last_request_path
    helper_method :last_request_page

    private

      def store_last_request_path
        return unless current_user&.admin?
        return unless request.get? && !request.xhr? && request.format.html?
        return unless request.path.start_with?("/admin")

        current_path = request.fullpath
        if session[:current_url].present? && session[:current_url] != current_path
          session[:previous_url] = session[:current_url]
        end
        session[:current_url] = current_path
      end

      def last_request_page(default = root_path)
        session[:previous_url] || default
      end
  end
end
