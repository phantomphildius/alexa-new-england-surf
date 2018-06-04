# frozen_string_literal: true

require 'vcr'
require 'faraday'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :faraday
  c.configure_rspec_metadata!
end
