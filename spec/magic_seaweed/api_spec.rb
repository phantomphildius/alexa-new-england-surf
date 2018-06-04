# frozen_string_literal: true

require 'magic_seaweed/api'
require 'json'

RSpec.describe MagicSeaweed::Api do
  describe 'forecast', :vcr do
    context 'without required fields' do
      it 'returns an error string' do
        api = MagicSeaweed::Api.new(spot_id: nil, fields: nil)

        response = api.forecast

        expect(response).to be_a(String)
        expect(response).to eq(magic_seaweed_error_msg)
      end
    end

    context 'without optional fields' do
      it 'responds with all data' do
        api = MagicSeaweed::Api.new(spot_id: 846, fields: nil)

        response = JSON.parse(api.forecast)

        expect(response).to be_a(Array)
        expect(response.length).to be(40)
        expect(response.first.keys).to match_array(full_response_keys)
      end
    end

    context 'with required and optional fields' do
      it 'responds with requested fields' do
        fields = 'localTimestamp,swell.components.combined.height'
        api = MagicSeaweed::Api.new(spot_id: 846, fields: fields)

        response = JSON.parse(api.forecast)

        expect(response).to be_a(Array)
        expect(response.length).to be(40)
        expect(response.first['localTimestamp']).to eq(1_528_070_400)
        expect(response.first.dig('swell', 'components', 'combined', 'height')).to eq(2.5)
      end
    end
  end

  def magic_seaweed_error_msg
    'Invalid parameters were supplied and did not pass'\
      ' our validation, please double check your request.'
  end

  def full_response_keys
    %w[timestamp localTimestamp issueTimestamp fadedRating solidRating swell wind condition charts]
  end
end
