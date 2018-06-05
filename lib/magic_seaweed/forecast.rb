module MagicSeaweed
  class Forecast

    def initialize(spot_id:, fields:)
      @spot_id = spot_id
      @fields = fields
    end

    def prediction

    end

    private

    def forecast
      MagicSeaweed::Api.new(spot_id: fields, fields: fields).forecast
    end
  end
end
