# frozen_string_literal: true

require 'json'

module MagicSeaweed
  # A wrapper for the handling the faraday response from the magic seaweed (msw) api
  # This class requires a `response` which is a faraday response
  # It has a single public method which returns either data as json or an error message string
  class Response
    attr_reader :response

    def initialize(response:)
      # TODO handle JSON parse errors
      @response = JSON.parse(response.body)
    end

    def body
      success? ? response : error_response
    end

    private

    def success?
      !error?
    end

    def error?
      response.is_a?(Hash) && response.dig('error_response', 'error_msg')
    end

    def error_response
      response.dig('error_response', 'error_msg')
    end
  end
end
