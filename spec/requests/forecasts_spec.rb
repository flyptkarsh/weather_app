# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Forecasts', type: :request do
  let(:geocode_address_response) do
    [
      {
        'lat' => '40.7681576',
        'lon' => '-73.9664751',
        'display_name' => '432 Park Avenue, New York, 10065, United States',
        'address' => {
          'house_number' => '432',
          'road' => 'Park Avenue',
          'postcode' => '10065'
        }
      }
    ]
  end

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
    # stub calls to the Geocoder API
    Geocoder.configure(lookup: :test, ip_lookup: :test)
    Geocoder::Lookup::Test.add_stub('432 Park Ave, New York', geocode_address_response)
    Geocoder::Lookup::Test.add_stub('', [])

    # stub calls to the OpenMeteo API
    stub_request(:get, /open-meteo/)
      .with(
        headers: api_headers
      ).to_return(body: response_body, status: 200, headers: reponse_headers)
  end

  describe 'POST /create' do
    context 'with valid params' do
      it 'redirects to the forecast page' do
        post forecasts_path, params: { address: '432 Park Ave, New York' }
        expect(response).to redirect_to(forecast_path(Forecast.last))
        expect(flash[:query]).to eq('432 Park Ave, New York')
        expect(flash[:address]).to eq('432 Park Avenue, New York, 10065, United States')
      end
    end

    context 'with invalid params' do
      it 'redirects to the new forecast page' do
        post forecasts_path, params: { address: '' }
        expect(response).to redirect_to(new_forecast_path)
        expect(flash[:error]).to eq('Unable to find location')
      end
    end
  end
end
