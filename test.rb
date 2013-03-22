require_relative 'app.rb'
require 'test/unit'
require 'rack/test'

class GrokilyTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Grokily 
  end

  def test_my_default
    get '/'
    follow_redirect!
    assert_equal "https://github.com/benjaminasmith/grokily", last_request.url
  end

end
