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
