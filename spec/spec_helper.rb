# encoding: UTF-8

require_relative '../lib/grokily'

require 'rspec'
require 'rack/test'

RSpec.configure do |config|
    config.include Rack::Test::Methods
end

def app
  Grokily
end
