class ApixuApi
  def self.weather_in(city)
    url = "http://api.apixu.com/v1/current.json?key=#{key}&q=#{city}"

    response = HTTParty.get url.to_s
    response.parsed_response["current"]
  end

  def self.key
    raise "APIXU_APIKEY env variable not defined" if ENV['APIXU_APIKEY'].nil?

    ENV['APIXU_APIKEY']
  end
end
