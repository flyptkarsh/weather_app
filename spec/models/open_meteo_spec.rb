require 'rails_helper'

RSpec.describe OpenMeteo, type: :model do
  before do
    # stub calls to the OpenMeteo API
    stub_request(:get, /open-meteo/)
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      ).to_return(body: {
        'current_weather' =>
           { 'temperature' => 28 }
      }.to_json, status: 200, headers: { content_type: 'application/json' })
  end

  describe '#temperature' do
    it 'returns the current temperature' do
      open_meteo = OpenMeteo.new(40.7681576, -73.9664751)
      expect(open_meteo.temperature).to eq(28)
    end
  end

  describe '#current_weather' do
    it 'returns the current weather' do
      open_meteo = OpenMeteo.new(40.7681576, -73.9664751)
      expect(open_meteo.current_weather).to eq({ 'temperature' => 28 })
    end
  end
end
