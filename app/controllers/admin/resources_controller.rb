class Admin::ResourcesController < Admin::BaseController
  
  # require created by them for edit / or admin user

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
end
