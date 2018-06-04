# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require './lib/magic_seaweed/api.rb'

get '/' do
  return 'missing spot id' if spot_id.nil? || spot_id.strip.empty?
  forecast_response
end

private

def spot_id
  params[:spot_id]
end

def forecast_response
  magic_seaweed_api.forecast
end

def magic_seaweed_api
  @magic_seaweed_api ||= MagicSeaweed::Api.new(spot_id: spot_id, fields: params[:fields])
end
