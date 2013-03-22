require_relative 'app.rb'
require 'test/unit'
require 'rack/test'

class GrokilyTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Grokily 
  end

  def test_root_route
    get '/'
    # Should redirect to the github repo.
    follow_redirect!
    assert_equal "https://github.com/benjaminasmith/grokily", last_request.url
  end

end
