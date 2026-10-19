class ResourcesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  def index
    @resources = Resource.all
  end

  def show
    require 'commonmarker'
    @resource = Resource.includes(author: :user, phases: :phase_resources).find(params[:id])
    @markdown = Commonmarker.to_html(@resource.description.body.to_html)
  end
end
