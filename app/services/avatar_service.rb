require 'avatar'

class AvatarService
  include HTTMultiParty

  if Rails.env.production?
    base_uri 'http://dapiavatar-api.herokuapp.com'
  else
    base_uri 'http://localhost:3002'
  end

  def initialize(args = {})
    # auth token would probably go here
    @args = args
  end

  def get(id)
    response = self.class.get("/avatars/#{id}")

    case response.code
    when 200
      Avatar.new(response["data"])
    when 404
      false
    end
  end

  def get_latest(profile_uuid)
    response = self.class.get("/avatars/show_latest/#{profile_uuid}")

    case response.code
    when 200
      Avatar.new(response["data"])
    when 404
      false
    end
  end

  def create(params)
    options = {
      body: {
        avatar: {
          profile_uuid: params["profile_uuid"],
          image: params["image"]
        }
      },
      detect_mime_type: true
    }
    response = self.class.post("/avatars", options)

    case response.code
    when 200
      Avatar.new(response["data"])
    when 404
      false
    end
  end
end

