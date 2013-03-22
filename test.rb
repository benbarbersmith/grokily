# encoding: UTF-8

require_relative 'app.rb'
require 'rspec'
require 'rack/test'

describe "Grokily" do
  include Rack::Test::Methods

  def app
    Grokily
  end

  it "redirects to Github on root" do
    get '/'
    last_response.should be_redirect
    follow_redirect!
    last_request.url.should == "https://github.com/benjaminasmith/grokily"
  end

  # Present tense tests

  it "conjugates the regular verb få in the present tense" do
    # Should be får
    get '/norsk/få/presens'
    last_response.body.should == "får"
  end

  it "conjugates the irregular verb burde in the present tense" do
    # Should be bør
    get '/norsk/burde/presens'
    last_response.body.should == "bør"
  end

  it "conjugates the irregular verb finnes in the present tense" do
    # Should be finnes 
    get '/norsk/finnes/presens'
    last_response.body.should == "finnes"
  end

  it "fails to conjugate unknown verbs in the present tense" do
    # Should be a 404
    get '/norsk/finish/presens'
    last_response.ok? == false 
  end

end
