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
    unless verbs[c.field(0)]["qualifier"].nil?
      verbs[c.field(0)].each_pair do |k, v|
        unless k == "english"
          verbs[c.field(0)][k] = v.split(", ").map do |f| 
            "#{f} (#{verbs[c.field(0)]["qualifier"]})"
          end.join(", ")
        end
      end
    end
  end
  verbs
end

def qualify(infinitive, verb)
  unless verb["qualifier"].nil?
    qualified_infinitive = (infinitive + " (" + verb["qualifier"] + ")")
  else
    infinitive
  end
end

def subjectify(conjugation, subject)
  expected = conjugation.split(", ").map do |c|
    if subject.size > 0 
      subject + " " + c
    else
      c
    end
  end.join(", ")
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


