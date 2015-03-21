class ArcgisService
  include HTTParty
  base_uri 'http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer'
  
  def initialize(args = {})
    @args = args
  end
  
  def getCoords(postal_code)
    postal_code = CGI.escape(postal_code)
    response = self.class.get("/findAddressCandidates?SingleLine=#{postal_code}&f=json")

    JSON.parse(response)["candidates"][0]["location"]
  end
end
