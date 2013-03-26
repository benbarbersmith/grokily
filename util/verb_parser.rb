#!/usr/bin/ruby

require 'csv'
require 'json'

def multi_verb? c
  c.fields.any? {|f| f.include? "/" unless f.nil? }
end

def process_single_verb c
  verb = { :infinitive => c.fields.first, 
           :english => c.fields[c.fields.size-2]}
  verb[:qualifier] = c.fields.last unless c.fields.last.nil?
  if c.any? {|k, v| v.include? "*" unless v.nil? } 
    verb[:irregularities] = []
    c.select {|k, v| v.include? "*" unless v.nil? }.each do |item| 
      irregularity = { item.first.downcase.to_sym => item.last[2..-1] }
      verb[:irregularities] << irregularity
    end
  end
  verb
end

def process_multi_verb c
  verb = { :infinitive => c.fields.first, 
           :english => c.fields[c.fields.size - 2] }
  verb[:qualifier] = c.fields.last unless c.fields.last.nil?
  verb[:irregularities] = []
  c.select {|k, v| v.include? "/" unless v.nil? }.each do |item| 
    irregularity = { item.first.downcase.to_sym => \
      item.last.split("/").map do |conj| 
        conj.strip.sub("* ", "")
      end
    }
    verb[:irregularities] << irregularity
  end
  verb
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
