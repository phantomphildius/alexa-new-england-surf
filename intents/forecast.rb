intent 'Forecast' do |spot_id|
  respond(MagicSeaweed::Forecast.new(spot_id: spot_id).forecast)
end
