class Avatar
  attr_accessor :id, :profile_uuid, :image_url_medium, :image_url_thumb,
    :created_at

  def initialize(args = {})
    self.id = args["id"]
    self.profile_uuid = args["profile_uuid"]
    self.image_url_medium = args["image_url_medium"]
    self.image_url_thumb = args["image_url_thumb"]
  end
end

