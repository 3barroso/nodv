class PhasesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  def index
    @phases = Phase.all
  end

  def show
    @phase = Phase.find(params[:id])
    # include parent phases // include child phases
  end
end
