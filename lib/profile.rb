class Profile
  attr_accessor :id, :email, :description, :display_name

  def initialize(args = {})
    self.id = args["id"]
    self.description = args["description"]
    self.email = args["email"]
    self.display_name = args["display_name"]
  end
end

