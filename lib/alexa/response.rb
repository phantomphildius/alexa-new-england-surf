VERSION = '0.1.0'.freeze

module Alexa
  class Response < Hash
    def initialize(response_text, session_attributes = {})
      @version = VERSION
      @response_text = response_text
      @session_attributes = session_attributes
    end

    # rubocop:disable Metrics/MethodLength
    def body
      {
        version: version,
        session_attributes: session_attributes,
        response: {
          outputSpeech: {
            type: 'PlainText',
            text: text
          }
        }
      }
    end
    # rubocop:enable Metrics/MethodLength
  end
end
