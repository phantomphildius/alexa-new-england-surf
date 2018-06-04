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

    attr_reader :spot_id, :fields

    def initialize(spot_id:, fields:)
      @spot_id = spot_id
      @fields = fields
    end

    def forecast
      response = connection.get('forecast', request_options)
      MagicSeaweed::Response.new(response: response).body
    end

    private

    def request_options
      {
        fields: fields,
        spot_id: spot_id,
        units: 'us'
      }.compact
    end

    def connection
      @connection ||= Faraday.new(url: URL)
    end
  end
end
