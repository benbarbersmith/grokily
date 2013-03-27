# encoding: UTF-8
require_relative 'spec_helper'

describe "Grokily" do

  it "redirects to Github on root" do
    get '/'
    last_response.should be_redirect
    follow_redirect!
    last_request.url.should == "https://github.com/benjaminasmith/grokily"
  end

  context "exposes a list of languages on request" do
    it "in plaintext" do
      get '/languages'
      last_response.should be_ok
      last_response.body.should =~ /norsk/
    end
    it "in json" do
      get '/languages.json'
      last_response.should be_ok
      last_response.header['Content-Type'].should include 'application/json'
      JSON.parse(last_response.body).has_key?("languages").should == true
    end
  end

  context "exposes a list of Norwegian verbs on request" do
    it "in plaintext" do
      get '/norsk/verbs'
      last_response.should be_ok
      last_response.body.should =~ /arrangere/
      last_response.body.should =~ /gre/
    end
    it "in json" do
      get '/norsk/verbs.json'
      last_response.should be_ok
      last_response.header['Content-Type'].should include 'application/json'
      verbs = JSON.parse(last_response.body)
      verbs.has_key?("verbs").should == true
      verbs["verbs"].any? { |v| v["infinitive"] == "arrangere" }.should == true
      verbs["verbs"].any? { |v| v["english"] == "arrange" }.should == true
    end
  end

end
