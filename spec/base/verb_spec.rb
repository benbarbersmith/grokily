# encoding: UTF-8
require_relative '../spec_helper'

describe "Verb" do

  it "should return a new verb object" do
    Verb.new(VALID_VERB_DICT).should be_a Verb
  end

  it "should throw an exception if the dictionary used
      to instantiate it does not contain an infinitive" do
    expect { 
      Verb.new(invalid_verb_dict(:infinitive))
    }.to raise_error InvalidVerbException
  end

  it "should throw an exception if the dictionary used 
      to instantiate it does not contain a translation" do
    expect { 
      Verb.new(invalid_verb_dict(:english))
    }.to raise_error InvalidVerbException
  end

  it "should throw an exception if the dictionary used 
      to instantiate it does not contain a translation" do
    expect { 
      Verb.new(INVALID_VERB_IRREGULARITIES_DICT) 
    }.to raise_error InvalidVerbException
  end

  context "with a valid verb" do
    let(:verb) { Verb.new VALID_VERB_DICT }
    let(:unqualified_verb) { Verb.new invalid_verb_dict(:qualifier) }
    let(:regular_verb) { Verb.new invalid_verb_dict(:irregularities) }

    describe ".to_s" do
      it "returns the infinitive" do
        expect(verb.to_s).to eq("Infinitive")
      end
    end

    describe ".to_hash" do
      it "returns the same content as our original input" do
        dict = {}
        VALID_VERB_DICT.each_pair { |k, v| dict[k.to_s.downcase] = v }
        dict.delete("irregularities")
        dict["irregularities"] = {}
        VALID_VERB_DICT[:irregularities].each_pair do |k, v|
          dict["irregularities"][k.downcase] = v 
        end
        expect(verb.to_hash).to eq(dict)
      end
    end

    describe ".qualified?" do
      it "returns true for a qualified verb" do
        verb.qualified?.should be true
      end

      it "returns false for an unqualified verb" do
        unqualified_verb.qualified?.should be false
      end
    end

    describe ".irregular?" do
      it "returns false for a regular verb" do
        regular_verb.irregular?("some").should be false 
        regular_verb.irregular?("other").should be false 
      end
      
      it "returns true for an irregular verb" do
        verb.irregular?("some").should be true 
        verb.irregular?("other").should be false 
      end
    end

    describe ".qualifier" do
      it "returns a qualifier if it has one" do
        expect(verb.qualifier).to eq VALID_VERB_DICT[:qualifier] 
      end

      it "returns nil if it does not" do
        expect(unqualified_verb.qualifier).to eq nil 
      end
    end

  end

end

VALID_VERB_DICT = {
  :infinitive => "Infinitive",
  :english => "English",
  :qualifier => "Qualifier",
  :irregularities => {"Some" => ["thing", "else"] }
}

INVALID_VERB_IRREGULARITIES_DICT = {
  :infinitive => "Infinitive",
  :english => "English",
  :qualifier => "Qualifier",
  :irregularities => [ "Some", "thing" ] 
}

def invalid_verb_dict item
  invalid_verb_dict = VALID_VERB_DICT.dup
  invalid_verb_dict.delete(item)
  invalid_verb_dict
end


