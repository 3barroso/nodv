class ResourcesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_resource, only: %i[ show ]
  before_action :check_resources_status, only: %i[ show ]


  def index
    @phases = Phase.main_phases.includes(:sub_phases)
    @phase_options = @phases.flat_map do |phase|
      [ [ phase.name, phase.id ] ] + phase.sub_phases.map { |sub_phase| [ "#{phase.name} / #{sub_phase.name}", sub_phase.id ] }
    end
    @audience_types = AudienceType.order(:name)
    @sort = %w[created_at_desc created_at_asc].include?(params[:sort]) ? params[:sort] : "created_at_desc"
    @phase_id = Phase.where(id: params[:phase_id]).pick(:id)&.to_s
    @audience_type_id = AudienceType.where(id: params[:audience_type_id]).pick(:id)&.to_s

    @resources = Resource.published.includes(:audience_types, phases: :parent)
    if @phase_id.present?
      phase = Phase.includes(:sub_phases).find(@phase_id)
      phase_ids = phase.parent_id.nil? ? [ phase.id, *phase.sub_phases.ids ] : [ phase.id ]
      @resources = @resources.where(id: Resource.joins(:phases).where(phases: { id: phase_ids }).select(:id))
    end
    if @audience_type_id.present?
      @resources = @resources.where(id: Resource.joins(:audience_types).where(audience_types: { id: @audience_type_id }).select(:id))
    end

    direction = @sort == "created_at_asc" ? :asc : :desc
    @resources = @resources.order(created_at: direction, id: direction)
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
