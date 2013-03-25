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
  verb = { :infinitive => c.fields.first, 
           :english => c.fields.last }
  if c.any? {|k, v| v.include? "*"} 
    verb[:irregularities] = []
    c.select {|k, v| v.include? "*"}.each do |item| 
      irregularity = { item.first.downcase.to_sym => item.last[2..-1] }
      verb[:irregularities] << irregularity
    end
  end
  verb
end

def process_multi_verb c
  verbs = []
  if not c.fields.first.include? "/"
    verb = { :infinitive => c.fields.first, 
             :english => c.fields.last }
    verb[:irregularities] = []
    c.select {|k, v| v.include? "/"}.each do |item| 
      irregularity = { item.first.downcase.to_sym => \
        item.last.split("/").map {|conjugation| conjugation.strip } }
      verb[:irregularities] << irregularity
    end
    verbs << verb
  else
    infinitives = c.fields.first.split("/").size
    (0..(infinitives-1)).each do |n|
      verb = {}
      verb = { :infinitive => c.fields.first.split("/")[n].strip,
               :english => c.fields.last }
      verb[:irregularities] = []
      irs = c.reject {|f| if f.first == "infinitive" then f end }
      irs = irs.select {|f| if f.last.split("/").size == infinitives then f end }
      irs.each do |item| 
        irregularity = { item.first.downcase.to_sym => \
          item.last.split("/")[n].strip }
        verb[:irregularities] << irregularity
      end
      verb.each_pair { |k, v| verb[k] = v.strip unless v.is_a? Array }
      verbs << verb
    end
  end
  verbs 
end

verbs = []

CSV.foreach(ARGV[0], :headers => true) do |c|
  verb = {}
  if multi_verb? c
    verb = process_multi_verb c
    verb.each {|v| verbs << v }
  else
    verb = process_single_verb c
    verbs << verb
  end
end

$stdout.puts verbs.to_json
