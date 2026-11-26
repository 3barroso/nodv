class ResourcesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_resource, only: %i[ show ]
  before_action :check_resources_status, only: %i[ show ]


  def index
    @resources = Resource.published.includes(:author, :phases).order(created_at: :desc)
  end

  def show
    @markdown = @resource.markdown_content
  end

  private

    def set_resource
      @resource = Resource.includes(author: :user, phases: :phase_resources).find(params[:id])
    end

    def check_resources_status
      unless @resource.status == "published" || current_user&.admin? || @resource.author&.user_id == current_user&.id
        redirect_to resources_path, alert: "Resource not found."
      end
    end
end
