class Admin::ResourcesController < Admin::BaseController
  before_action :set_resource, only: [:edit, :destroy]
  before_action :ensure_resource_access, only: [:edit, :destroy]

  def create
  end

  def destroy
  end

  def edit
  end

  def index
    @resources = Resource.all.includes(:phases)
  end

  def new
  end

  private
    def set_resource
      @resource = Resource.find(params[:id])
    end

    def ensure_resource_access
      unless @resource.manageable_by?(current_user)
        redirect_to root_path, alert: "Access Denied."
      end
    end
end
