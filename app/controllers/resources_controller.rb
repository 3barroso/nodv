class ResourcesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  def index
    @resources = Resource.all
  end

  def show
    @resource = Resource.find(params[:id])
  end
  
  # permitted params ?
end
