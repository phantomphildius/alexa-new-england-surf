intent 'Forecast' do |spot_id, fields = nil|
  forecast = MagicSeaweed::Api.new(spot_id: spot_id, fields: fields).forecast
  respond(forecast)
end
