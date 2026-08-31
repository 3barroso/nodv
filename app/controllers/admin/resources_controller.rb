class Admin::ResourcesController < Admin::BaseController
  before_action :set_resource, only: [ :edit, :update, :destroy ]
  before_action :ensure_resource_access, only: [ :edit, :update, :destroy ]

  def create
  end

  def destroy
  end

  def edit
  end

  def update
    if @resource.update(resource_params)
      redirect_to admin_resources_path, notice: "Resource updated."
    else
      flash.now[:alert] = @resource.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
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
    
    def resource_params
      params.require(:resource).permit(:name, :description, :status, :author_id)
    end
end
