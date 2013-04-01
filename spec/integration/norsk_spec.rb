# encoding: UTF-8

require_relative '../spec_helper'

language = "norsk"

subjects = [
  "", "jeg", "du", "han", "hun", "den", "det", "vi", "dere", "de"
]

tenses = {
  "present" => ["present", "presens"],
  "past" => ["past", "fortid"],
  "future" => ["future", "futurum"],
}

forms = {
  "stem" => ["stem", "demme"],
  "imperative" => ["imperative", "viktig"],
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
        list.should include t
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
      verbs.keys.each do |infinitive|
        infinitives.should include infinitive
        translations.should include verbs[infinitive]["english"]
      end
    end

  end

  context "exposes a list of Norwegian subjects on request" do

    it "in plaintext" do
      get '/norsk/subjects'
      last_response.should be_ok
      last_response.header['Content-Type'].should include 'text/plain'
      subjects.each do |subject|
        last_response.body.should include subject
      end
    end

    it "in json" do
      get '/norsk/subjects.json'
      last_response.should be_ok
      last_response.header['Content-Type'].should include 'application/json'
      resp = JSON.parse(last_response.body)
      resp.has_key?("subjects").should == true
      list = resp["subjects"]
      subjects.select { |s| s.size > 0 }.each do |subject|
        list.should include subject
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

  context "a fake subject" do
    it "halts with a 404" do
      get URI.encode "/norsk/#{verbs.keys[rand(verbs.size)]}/#{tenses.keys[rand(tenses.size)]}/fake"
      last_response.status.should be 404
    end
  end
end

tenses.each_pair do |tense, tense_keys|
  subjects.each do |subject|
    describe scenario(tense, subject) do
      verbs.each_pair do |infinitive, verb|

        # Setup variables used in tests
        qualified_infinitive = qualify(infinitive, verb)
        expected_result = subjectify(verb[tense], subject) 

        context "conjugates #{infinitive} to #{expected_result.join(", ")}" do
          tense_keys.each do |tense_key|

            it "using #{tense_key} in plain text" do
              get conjugation_url(language, infinitive, tense_key, subject)
              last_response.should be_ok
              last_response.header['Content-Type'].should include 'text/plain'
              expected_result.each do |e|
                last_response.body.should include e
              end
            end

            it "using #{tense_key} in JSON" do
              json_conjugation_test(language, verb, infinitive,
                                    qualified_infinitive, tense, tense_key,
                                    subject, expected_result)
            end

          end
        end
      end
    end
  end
end

forms.each_pair do |tense, tense_keys|
  subjects.each do |subject|
    if subject.size == 0

      describe scenario(tense, subject) do
        verbs.each_pair do |infinitive, verb|

          # Setup variables used in tests
          expected_result = verb[tense].split(", ")
          qualified_infinitive = qualify(infinitive, verb)

          context "conjugates #{infinitive} to #{expected_result.join(", ")}" do
            tense_keys.each do |tense_key|

              it "using #{tense_key} in plain text" do
                get conjugation_url(language, infinitive, tense_key, subject)
                last_response.should be_ok
                last_response.header['Content-Type'].should include 'text/plain'
                expected_result.each do |e|
                  last_response.body.should include e
                end
              end

              it "using #{tense_key} in JSON" do
                json_conjugation_test(language, verb, infinitive,
                                      qualified_infinitive, tense, tense_key,
                                      subject, expected_result)
              end
            end
          end
        end
      end

    else

    describe scenario(tense, subject) do
      verbs.each_pair do |infinitive, verb|
        context "should throw an Exception" do
          tense_keys.each do |tense_key|

            it "using #{tense_key} in plain text" do
              get conjugation_url(language, infinitive, tense_key, subject)
              last_response.status.should be 404 
            end

            it "using #{tense_key} in JSON" do
              get conjugation_url(language, infinitive, 
                                  tense_key, subject, ".json")
              last_response.status.should be 404 
            end

          end
        end
      end
    end

    end
  end
end
