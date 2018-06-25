# frozen_string_literal: true

require 'faraday'
require './lib/magic_seaweed/response.rb'

module MagicSeaweed
  # A wrapper for the faraday connection to the magic seaweed (msw) api
  # This class requires a `spot_id`: string
  # it also takes an optional `fields` arguement: comma separated string of msw metrics
  # it has a single public method `forecast` which returns a faraday response object
  class Api
    URL = "https://magicseaweed.com/api/#{token}"

    def self.get(action, options=nil)
      response = connection.get(action, options)
      MagicSeaweed::Response.new(response: response).body
    end

    private

    def connection
      @connection ||= Faraday.new(url: URL)
    end
  end
end
