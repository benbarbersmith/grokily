# encoding: UTF-8

require_relative 'grokily.rb'
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

  context "regular verb få" do
    it "conjugates in the present tense to får" do
      get '/norsk/få/present'
      last_response.body.should == "får"
    end

    context "presens" do
      it "conjugates in presens to får" do
        get '/norsk/få/presens'
        last_response.body.should == "får"
      end
    end
  end

  context "irregular verb burde" do
    it "conjugates in the present tense to bør" do
      get '/norsk/burde/present'
      last_response.body.should == "bør"
    end

    it "conjugates in presens to bør" do
      get '/norsk/burde/presens'
      last_response.body.should == "bør"
    end
  end

  context "irregular verb finnes" do
    it "conjugates in the present tense to finnes" do
      get '/norsk/finnes/present'
      last_response.body.should == "finnes"
    end

    it "conjugates in presens to finnes" do
      get '/norsk/finnes/presens'
      last_response.body.should == "finnes"
    end
  end

  context "unknown verb" do
    it "fails to conjugate in the present tense" do
      get '/norsk/finish/present'
      last_response.ok? == false 
    end

    it "fails to conjugate in presens" do
      get '/norsk/finish/presens'
      last_response.ok? == false 
    end
  end


end
