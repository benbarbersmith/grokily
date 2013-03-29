# encoding: UTF-8

class Verb
  attr_accessor :infinitive, :english

  def initialize verb
    @infinitive = verb[:infinitive] or raise InvalidVerbException
    @english = verb[:english] or raise InvalidVerbException
    @irregularities = {} unless verb[:irregularities].nil?
    unless verb[:irregularities].nil? 
      begin
        verb[:irregularities].each_pair {|k, v| @irregularities[k] = v } 
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
      hash[var.to_s.delete("@")] = instance_variable_get(var)
    end
    hash
  end 

  public 

  def conjugate tense
    if irregular? tense
      # Return the listed irregularity for this tense.
      Conjugation.new(self, @irregularities[tense.to_sym])
    else
      # Conjugate the verb according to normal tense rules.
      Conjugation.new(self, tense.regular_conjugation(self))
    end
  end

  def qualified? 
    instance_variables.include? :@qualifier
  end

  def qualifier
    @qualifier if qualified?
  end

  def irregular? tense
    instance_variables.include? :@irregularities and 
    @irregularities[tense.to_sym]
  end
end

class InvalidVerbException < Exception
end
