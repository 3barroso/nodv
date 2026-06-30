class PhasesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  def index
    @phases = Phase.all
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
