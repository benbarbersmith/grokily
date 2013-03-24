#!/usr/bin/ruby

require 'csv'
require 'json'

verbs = []

CSV.foreach(ARGV[0], :headers => true) do |c|
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
  verbs << verb
end

$stdout.puts verbs.to_json
