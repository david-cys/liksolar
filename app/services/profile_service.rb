require 'profile'

class ProfileService
  include HTTParty

  if Rails.env.production?
    base_uri 'http://dapi-api.herokuapp.com'
  else
    base_uri 'http://localhost:3001'
  end

  def initialize(args = {})
    # auth token would probably go here
    @args = args
  end

  def get(id)
    response = self.class.get("/profiles/#{id}")

    case response.code
    when 200
      Profile.new(response["data"])
    when 404
      false
    end
  end

  def create(params)
    options = {
      body: {
        profile: params
      }
    }
    response = self.class.post("/profiles", options)

    case response.code
    when 200
      Profile.new(response["data"])
    when 404
      false
    end
  end

  def list
    response = self.class.get("/profiles")

    case response.code
    when 200
      profile_array = []
      response["data"].each do |profile|
        profile_array << Profile.new(profile)
      end
    when 404
      false
    end
    profile_array
  end

  def search(query)
    response = self.class.get("/profiles?query=#{query.parameterize}")

    case response.code
    when 200
      profile_array = []
      response["data"].each do |profile|
        profile_array << Profile.new(profile)
      end
    when 404
      false
    end
    profile_array
  end
end

