# encoding: UTF-8
require_relative '../spec_helper'

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

end
