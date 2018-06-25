# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require './lib/alexa/skill.rb'

post '/' do
  return 'missing spot id' if spot_id.nil? || spot_id.strip.empty?
  Alexa::Handlers.handle(request)
end

private

def spot_id
  params[:spot_id]
end
