# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenMeteo, type: :model do
  let(:api_headers) do
    {
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent' => 'Ruby'
    }
  end

  let(:response_body) do
    {
      'current_weather' =>
           { 'temperature' => 28 }
    }.to_json
  end

  let(:reponse_headers) do
    { content_type: 'application/json' }
  end

  before do
    # stub calls to the OpenMeteo API
    stub_request(:get, /open-meteo/)
      .with(
        headers: api_headers
      ).to_return(body: response_body, status: 200, headers: reponse_headers)
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
