class ResourcesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  def index
    @resources = Resource.all
  end

  def show
    @resource = Resource.includes(author: :user, phases: :phase_resources).find(params[:id])
  end
end
