# frozen_string_literal: true

# Controller for the forecast pages
class ForecastsController < ApplicationController
  before_action :set_location, only: %i[create]

  def new; end

  def create
    if @location.present? && set_forecast_by_location
      flash[:query] = params[:address]
      flash[:address] = @location[:display_name]
      redirect_to forecast_path(@forecast)
    else
      flash[:error] = 'Unable to find location'
      redirect_to new_forecast_path
    end
  end

  def show
    @forecast = Forecast.find(params[:id])
  end

  private

  def set_location
    @location = geocode_address
  end

  def set_forecast_by_location
    # locations are unique by zip code
    @forecast = Forecast.find_or_initialize_by(zip_code: @location[:zip_code])
    set_current_temperature
  end

  def set_current_temperature
    return true unless @forecast.last_updated_over_30_minutes_ago?

    # only update if the forecast is older than 30 minutes
    @forecast.current_temperature = OpenMeteo.new(@location[:lat], @location[:lng]).temperature
    @forecast.save!
  end

  def geocode_address
    # for simplicity I am only using the first result with a postal code in the response
    Geocoder.search(params[:address]).each do |r|
      if r.data.dig('address', 'postcode')

        return { lat: r.data['lat'],
                 lng: r.data['lon'],
                 zip_code: r.data.dig('address', 'postcode'),
                 display_name: r.data['display_name'] }
      end
    end
  end
end
