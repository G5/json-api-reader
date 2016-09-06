$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'json_api_reader'
require 'webmock/rspec'
require 'rspec/its'

Dir[File.join('spec/support/**/*.rb')].each { |f| require "./#{f}" }

RSpec.configure do |config|
  config.include FixturesHelper
end

def indifferent_hash(json)
  JSON.parse(json).with_indifferent_access
end
