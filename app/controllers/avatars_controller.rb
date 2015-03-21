class AvatarsController < ApplicationController
  def new
    @profile_uuid = params[:profile_uuid]
  end

  def create
    avatar_service = AvatarService.new
    @avatar = avatar_service.create(
      "profile_uuid" => params["profile_uuid"],
      "image" => params["image"]
    )
    if @avatar
      redirect_to profile_path(@avatar.profile_uuid)
    else
      render text: "Not Found", status: 404
    end
  end
end

