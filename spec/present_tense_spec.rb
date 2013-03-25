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

  context "conjugates the irregular verb lide to lider" do
    it "using present" do
      get URI.encode '/norsk/lide/present'
      last_response.should be_ok
      last_response.body.should == "lider"
    end

    it "using presens" do
      get URI.encode '/norsk/lide/presens'
      last_response.should be_ok
      last_response.body.should == "lider"
    end
  end

  context "conjugates the irregular verb li to lider" do
    it "using present" do
      get URI.encode '/norsk/li/present'
      last_response.should be_ok
      last_response.body.should == "lider"
    end

    it "using presens" do
      get URI.encode '/norsk/li/presens'
      last_response.should be_ok
      last_response.body.should == "lider"
    end
  end

  context "conjugates the irregular verb synes to synes or syns" do
    it "using present" do
      get URI.encode '/norsk/synes/present'
      last_response.should be_ok
      last_response.body.should == "synes / syns"
    end

    it "using presens" do
      get URI.encode '/norsk/synes/presens'
      last_response.should be_ok
      last_response.body.should == "synes / syns"
    end
  end

  context "conjugates the irregular verb flyge to synes or flyr" do
    it "using present" do
      get URI.encode '/norsk/flyge/present'
      last_response.should be_ok
      last_response.body.should == "flyr"
    end

    it "using presens" do
      get URI.encode '/norsk/flyge/presens'
      last_response.should be_ok
      last_response.body.should == "flyr"
    end
  end

  context "conjugates the irregular verb fly to synes or flyr" do
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
