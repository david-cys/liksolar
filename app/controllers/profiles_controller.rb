class ProfilesController < ApplicationController
  def index
    profile_service = ProfileService.new
    @profiles = profile_service.list
  end

  def new
  end

  def create
    profile_service = ProfileService.new
    @profile = profile_service.create(
      "display_name" => params["display_name"],
      "description" => params["description"],
      "email" => params["email"]
    )
    if @profile
      redirect_to profile_path(@profile.id)
    else
      render text: "Not Found", status: 404
    end
  end

  def show
    profile_service = ProfileService.new
    @profile = profile_service.get(params[:id])
    avatar_service = AvatarService.new
    @avatar = avatar_service.get_latest(@profile.id)
    render text: "Not found", status: 404 if !@profile
  end

  def search
    if params.has_key?(:query)
      profile_service = ProfileService.new
      @profiles = profile_service.search(params[:query])
    end
  end
end

