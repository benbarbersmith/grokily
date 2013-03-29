# encoding: UTF-8

class Verb
  attr_accessor :infinitive, :english

  def initialize verb
    @infinitive = verb[:infinitive] or raise InvalidVerbException
    @english = verb[:english] or raise InvalidVerbException
    @irregularities = {} unless verb[:irregularities].nil?
    unless verb[:irregularities].nil? 
      begin
        verb[:irregularities].each_pair {|k, v| @irregularities[k.downcase.to_sym] = v } 
      rescue 
        raise InvalidVerbException
      end
    end
    if verb.has_key? :qualifier then @qualifier = verb[:qualifier] end
  end

  def to_s
    self.infinitive 
  end

  def to_hash
    hash = {}
    instance_variables.each do |var| 
      unless var == :@irregularities
        hash[var.to_s.delete("@")] = instance_variable_get(var) 
      end
    end
    if instance_variables.include? :@irregularities
      hash["irregularities"] = {}
      @irregularities.each_pair do |k, v|
        hash["irregularities"][k.to_s.downcase ] = v
      end
    end
    hash
  end 

  public 

  def conjugate(tense, subject)
    if irregular? tense
      # Return the listed irregularity for this tense.
      Conjugation.new(self, "#{subject} #{@irregularities[tense.to_sym]}")
    else
      # Conjugate the verb according to normal tense rules.
      Conjugation.new(self, tense.regular_conjugation(self, subject))
    end
  end

  def qualified? 
    instance_variables.include? :@qualifier
  end

  def qualifier
    @qualifier if qualified?
  end

  def irregular? tense
    instance_variables.include?(:@irregularities) and
    not @irregularities[tense.to_sym].nil?
  end
end

class InvalidVerbException < Exception
end
