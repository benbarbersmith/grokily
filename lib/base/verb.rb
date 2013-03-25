# encoding: UTF-8

class Verb
  attr_accessor :infinitive, :english

  def initialize verb
    @infinitive = verb[:infinitive]
    @english = verb[:infinitive] 
    @irregularities = {} unless verb[:irregularities].nil?
    unless verb[:irregularities].nil? 
      verb[:irregularities].each do |d| 
        d.each_pair {|k, v| @irregularities[k] = v } 
      end
    end
  end

  def to_hash
    hash = {}
    instance_variables.each do |var| 
      hash[var.to_s.delete("@")] = instance_variable_get(var)
    end
    hash
  end 

  public 

  def conjugate tense
    if irregular?
      @irregularities[tense.to_sym]
    else
      tense.regular_conjugation self
    end
  end

  def irregular?
    instance_variables.include? :@irregularities
  end
end
