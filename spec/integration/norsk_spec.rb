# encoding: UTF-8

require_relative '../spec_helper'

tenses = {
  "present" => ["present", "presens"],
}

verbs = read_verb_data("data/norsk_verbs.csv")

describe "To show users what they can do, Grokily" do
  context "exposes a list of Norwegian tenses on request" do

    it "in plaintext" do
      get '/norsk/tenses'
      last_response.should be_ok
      last_response.header['Content-Type'].should include 'text/plain'
      tenses.values.flatten.uniq.each do |tense|
        last_response.body.should =~ Regexp.new(tense)
      end
    end

    it "in json" do
      get '/norsk/tenses.json'
      last_response.should be_ok
      last_response.header['Content-Type'].should include 'application/json'
      resp = JSON.parse(last_response.body)
      resp.has_key?("tenses").should == true
      list = resp["tenses"].map(&:values).flatten.uniq
      tenses.values.flatten.uniq.each do |t|
        list.include?(t).should == true
      end
    end

  end

  context "exposes a list of Norwegian verbs on request" do

    it "in plaintext" do
      get '/norsk/verbs'
      last_response.should be_ok
      last_response.header['Content-Type'].should include 'text/plain'
      verbs.keys.each do |infinitive|
        last_response.body.should =~ Regexp.new(infinitive)
      end
    end

    it "in json" do
      get '/norsk/verbs.json'
      last_response.should be_ok
      last_response.header['Content-Type'].should include 'application/json'
      resp = JSON.parse(last_response.body)
      resp.has_key?("verbs").should == true
      list = resp["verbs"]
      infinitives = list.map { |v| v["infinitive"] }
      translations = list.map { |v| v["english"] }
      list.each do |v|
        infinitives.include?(v["infinitive"]).should == true
        translations.include?(v["english"]).should == true
      end
    end

  end

end

describe "When asked for unrecognised content such as" do

  context "a fake tense" do
    it "halts with a 404" do
      get URI.encode "/norsk/#{verbs.keys[rand(verbs.size)]}/fake"
      last_response.status.should be 404
    end
  end

  context "a fake verb" do
    it "halts with a 404" do
      get URI.encode "/norsk/fake/#{tenses.keys[rand(tenses.size)]}"
      last_response.status.should be 404
    end
  end

end

tenses.each_pair do |tense, tense_keys|
  describe "In the #{tense} tense, Grokily" do

    verbs.each_pair do |infinitive, verb|
      conjugation = verb[tense]

      context "conjugates #{infinitive} to #{conjugation}" do

        tense_keys.each do |tense_key|
          it "using #{tense_key} in plain text" do
            get URI.encode "/norsk/#{infinitive}/#{tense_key}"
            last_response.should be_ok
            last_response.header['Content-Type'].should include 'text/plain'
            last_response.body.should include conjugation
          end

          it "using #{tense_key} in JSON" do
            get URI.encode "/norsk/#{infinitive}/#{tense_key}.json"
            last_response.should be_ok
            last_response.header['Content-Type'].should include 'application/json'
            resp = JSON.parse(last_response.body)
            resp.has_key?("conjugations").should == true
            list = resp["conjugations"]
            conjugation.split(", ").each do |expected|
              list.map { |c| c["conjugation"] }.flatten.any? do |v| 
                v.include? expected
              end.should == true 
            end
          end
        end

      end
    end

  end
end
