# frozen_string_literal: true

class OpenMeteo
  include HTTParty
  base_uri 'https://api.open-meteo.com'

  def initialize(lat, lng)
    @options = { query: { latitude: lat, longitude: lng, current_weather: true, temperature_unit: 'fahrenheit' } }
  end

  def weather_data
    self.class.get('/v1/forecast', @options)
  end

  def current_weather
    weather_data['current_weather']
  end

  def temperature
    current_weather['temperature']
  end
end
