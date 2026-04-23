class AuthorsController < ApplicationController
  allow_unauthenticated_access only: [ :show ]

  def show
    @author = Author.includes(published_resources: :phases).find(params[:id])
  end
end
