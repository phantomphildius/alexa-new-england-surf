# frozen_string_literal: true

require 'faraday'
require 'json'
require 'magic_seaweed/response'

RSpec.describe MagicSeaweed::Response do
  describe '.body' do
    context 'when successful' do
      it 'returns json data' do
        surf_data = [
          { waves: 'are good' },
          { waves: 'still good' },
          { waves: 'totally tubular' }
        ]
        server = stub_seaweed_api(surf_data)

        json_response = MagicSeaweed::Response.new(response: server.get('/forecast')).body
        parsed_response = JSON.parse(json_response)

        expect(json_response).to be_a(String)
        expect(parsed_response.length).to be(3)
        expect(parsed_response).to all(include('waves'))
      end

      it 'returns json data without error key' do
        not_an_error = { foo: 'this is another response type' }
        server = stub_seaweed_api(not_an_error)

        response = MagicSeaweed::Response.new(response: server.get('/forecast')).body

        expect(response).to eq(not_an_error.to_json)
      end
    end

    context 'when unsuccessful' do
      it 'returns an error string' do
        error = { error_response: { error_msg: 'yo dog there was an error' } }
        server = stub_seaweed_api(error)

        response = MagicSeaweed::Response.new(response: server.get('/forecast')).body

        expect(response).to be_a(String)
        expect(response).to eq(error[:error_response][:error_msg])
      end
    end

    def stub_seaweed_api(data_to_return)
      Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.get('/forecast') { [200, {}, data_to_return.to_json] }
        end
      end
    end
  end
end
