require 'time'
require 'date'

module MagicSeaweed
  class Forecast
    FIELDS = 'localTimestamp,swell.components.combined,wind,weather'
    FORECAST_HOURS = [0, 1, 2, 3, 6, 12].freeze

    def initialize(spot_id:, fields: FIELDS)
      @spot_id = spot_id
      @fields = fields
    end

    def forecast
      FORECAST_HOURS.map do |num_hours|
        forecast_time = Time.now + num_hours.hours
        "In #{num_hours} #{waves_forecast_at(forecast_time)} "\
        " while #{wind_forecast_at(forecast_time)}"\
        "and #{temp_forecast_for(forecast_time)}"
      end.join(' ')
    end

    private

    def waves_forecast_at(time = Time.now)
      return 'error in the api' if forecast_api_response.failure? # TODO better error naming/handling
      current_swell = forecast_for(time)[:swell][:components][:combind]

      "The swell is #{current_swell[:height]} high in a #{current_swell[:compass_direction]}"\
      " direction at a #{current_swell[:period]} second period."
    end

    def wind_forecast_at(time = Time.now)
      return 'error in the api' if forecast_api_response.failure? # TODO better error naming/handling
      current_wind = forecast_for(time)[:condition][:wind]

      "There is #{current_wind[:compassDirection]} wind"\
      "blowing #{current_wind[:speed]} miles per hour"
    end

    def temp_forecast_at(time = Time.now)
      return 'error in the api' if forecast_api_response.failure? # TODO better error naming/handling
      current_temp = forecast_for(time)[:condition][:temperature]

      "Its #{current_temp} degrees farenheit"
    end

    def forecast_for(time)
      # TODO stop naming block parameters `hash`
      current_forecast.find { |hash| hash[:localTimestamp].utc > time.utc }
    end

    def current_forecast
      #TODO parallelize this action
      @current_forecast ||= forecast_api_response.select do |hash|
        hash[:localTimestamp].utc > Time.now.utc
      end
    end

    def forecast_api_response
      @forecast_api_response ||= begin
        options = { fields: fields, spot_id: spot_id, units: 'us' }
        MagicSeaweed::Api.get('forecast', options)
      end
    end
  end
end
