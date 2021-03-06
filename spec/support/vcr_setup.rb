# frozen_string_literal: true

require "vcr"

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = "spec/vcr_cassettes"
  c.hook_into :webmock

  c.configure_rspec_metadata!
end
