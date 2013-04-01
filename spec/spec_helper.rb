# encoding: UTF-8

require 'simplecov'
SimpleCov.start
require 'rspec'
require 'rack/test'
require 'csv'

require_relative '../lib/grokily'

RSpec.configure do |config|
    config.include Rack::Test::Methods
end

def app
  Grokily
end

def read_verb_data file
  verbs = {}
  CSV.foreach(file, :headers => true) do |c|
    verbs[c.field(0)] = {} 
    headers = c.headers
    (1..c.fields.size-1).each do |n|
      unless c.field(n).nil?
        verbs[c.field(0)][headers[n]] = c.field(n).gsub("* ","").gsub(" / ",", ")
      end
    end
  end
  verbs
end

def qualify(phrase, verb)
  unless verb["qualifier"].nil?
    qualified_phrase = (phrase + " (" + verb["qualifier"] + ")")
  else
    phrase
  end
end

def subjectify(conjugation, subject)
  expected = conjugation.split(", ").map do |c|
    if subject.size > 0 
      subject + " " + c
    else
      c
    end
  end
end

def scenario(tense, subject)
  "In the #{tense} tense" + 
    if subject.size > 0 then " for subject #{subject}" else "" end +
    ", Grokily"
end

def conjugation_url(language, infinitive, tense_key, subject, format="")
  subject = if subject.size > 0 then "/" + subject else "" end
  URI.encode("/" + language + "/" + infinitive + "/" + 
             tense_key + subject + format)
end

def json_conjugation_test(language, verb, infinitive, qualified_infinitive, tense, tense_key, subject, expected_result)
              get conjugation_url(language, infinitive, 
                                  tense_key, subject, ".json")
              last_response.should be_ok
              last_response.header['Content-Type'].should include 'application/json'
              resp = JSON.parse(last_response.body)
              resp.keys.should include ("conjugations")
              resp["conjugations"].each do |c| 
                c["verb"].should include infinitive or qualified_infinitive 
                c["tense"].should eq tense
                c["subject"].should eq subject if subject.size > 0
              end
              resp["conjugations"].map do |c|
                c["qualifier"] 
              end.flatten.should include verb["qualifier"]
              expected_result.each do |e|
                resp["conjugations"].map do |c|
                  c["conjugation"]
                end.flatten.should include e 
              end
end
