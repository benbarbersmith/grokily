# encoding: UTF-8
require_relative 'spec_helper'

describe "In the present tense, Grokily" do

  context "conjugates the regular verb få to får" do
    it "using present" do
      get URI.encode '/norsk/få/present'
      last_response.should be_ok
      last_response.body.should == "får"
    end

    it "using presens" do
      get URI.encode '/norsk/få/present'
      last_response.should be_ok
      last_response.body.should == "får"
    end
  end

  context "conjugates the irregular verb burde to bør" do
    it "using present" do
      get URI.encode '/norsk/burde/present'
      last_response.should be_ok
      last_response.body.should == "bør"
    end

    it "using presens" do
      get URI.encode '/norsk/burde/presens'
      last_response.should be_ok
      last_response.body.should == "bør"
    end
  end

  context "conjugates the irregular verb fly to flyr" do
    it "using present" do
      get URI.encode '/norsk/fly/present'
      last_response.should be_ok
      last_response.body.should == "flyr"
    end

    it "using presens" do
      get URI.encode '/norsk/fly/presens'
      last_response.should be_ok
      last_response.body.should == "flyr"
    end
  end

  context "conjugates the irregular verb finnes to finnes" do
    it "using present" do
      get URI.encode '/norsk/finnes/present'
      last_response.should be_ok
      last_response.body.should == "finnes"
    end

    it "using presens" do
      get URI.encode '/norsk/finnes/presens'
      last_response.should be_ok
      last_response.body.should == "finnes"
    end
  end

  context "fails to conjugate an unknown verb" do
    it "using present" do
      get URI.encode '/norsk/test/present'
      last_response.should be_not_found
    end

    it "using presens" do
      get URI.encode '/norsk/test/presens'
      last_response.should be_not_found
    end
  end

end
