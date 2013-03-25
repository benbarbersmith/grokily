#!/usr/bin/ruby

require 'csv'
require 'json'

def multi_verb? c
  c.fields.any? {|f| f.include? "/"}
end

def all_fields_match? c
  infinitives = c.fields.first.split("/").size
  c.fields.any? {|f| f.split("/").size != infinitives }
end

def process_single_verb c
  verb = {
           :infinitive => c.fields.first, 
           :english => c.fields.last, 
         }
  if c.any? {|k, v| v.include? "*"} 
    verb[:irregularities] = []
    c.select {|k, v| v.include? "*"}.each {|item| 
      irregularity = { item.first.downcase.to_sym => item.last[2..-1] }
      verb[:irregularities] << irregularity
    }
  end
end

def process_multi_verb c
  verbs = []
  unless c.fields.first.include? "/"
    verb = {
             :infinitive => c.fields.first, 
             :english => c.fields.last, 
           }
    verb[:irregularities] = []
    c.select {|k, v| v.include? "/"}.each {|item| 
      irregularity = { item.first.downcase.to_sym => item.last.split("/") }
      verb[:irregularities] << irregularity
    }
    verbs << verb
  else if all_fields_match? c
    [0..(c.fields.first.split("/").size-1)].each {|n|
      verb = {
               :infinitive => c.fields.first.split("/")[n], 
               :english => c.fields.last.split("/")[n], 
             }
        verb[:irregularities] = []
        c.select {|k, v| v.include? "/"}.each {|item| 
          irregularity = { item.first.downcase.to_sym => item.last.split("/")[n] }
          verb[:irregularities] << irregularity
        }
      verbs << verb
    }
    end
  end
  verbs 
end

verbs = []

CSV.foreach(ARGV[0], :headers => true) do |c|
  verb = {}
  if multi_verb? c
    verb = process_multi_verb c
  else
    verb = process_single_verb c
  end
  verbs << verb
end

$stdout.puts verbs.to_json
