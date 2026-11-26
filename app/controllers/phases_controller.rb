class PhasesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  def index
    @phases = Phase.main_phases
    @sub_phases_by_parent_id = Phase.sub_phases.order(:position).group_by(&:parent_id)
    phase_ids = @phases.flat_map do |phase|
      [ phase.id, *@sub_phases_by_parent_id.fetch(phase.id, []).map(&:id) ]
    end
    @phase_resources_by_phase_id = if phase_ids.any?
      PhaseResource.includes(resource: [:resource_audience_types])
        .joins(:resource)
        .where(phase_id: phase_ids, resources: { status: Resource.statuses[:published] })
        .order("resources.name")
        .group_by(&:phase_id)

    else
      {}
    end
  end

  def show
    @phase = Phase.includes(
      phase_resources: :resource,
      sub_phases: { phase_resources: :resource }
    ).find(params[:id])

    @sub_phases = @phase.sub_phases.order(:position)
    @phase_resources = @phase.resources.order(:name)
  end
end
