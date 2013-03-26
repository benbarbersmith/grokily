# encoding: UTF-8

class Verb
  attr_accessor :infinitive, :english 

  def initialize verb
    @infinitive = verb[:infinitive]
    @english = verb[:english] 
    @irregularities = {} unless verb[:irregularities].nil?
    unless verb[:irregularities].nil? 
      verb[:irregularities].each do |irregularity| 
        irregularity.each_pair {|k, v| @irregularities[k] = v } 
      end
    end
    if verb.has_key? :qualifier then @qualifier = verb[:qualifier] end
  end

  def to_hash
    hash = {}
    instance_variables.each do |var| 
      hash[var.to_s.delete("@")] = instance_variable_get(var)
    end
    hash
  end 

  def qualify conjugation 
    "#{conjugation} (#{@qualifier})"
  end

  public 

  def conjugate tense
    conjugation = ""
    if irregular? tense
      # Return the listed irregularity for this tense.
      conjugation = @irregularities[tense.to_sym]
    else
      # Conjugate the verb according to normal tense rules.
      conjugation = tense.regular_conjugation self
    end
    if qualified?
      conjugation = qualify conjugation
    end
    puts to_hash 
    conjugation
  end

  def qualified? 
    instance_variables.include? :@qualifier
  end

  def irregular?(tense = false)
    # Are there any irregularities at all? If not, there's nothing to do.
    if instance_variables.include? :@irregularities
      if tense
        # A verb might be irregular, but it should not be considered to be
        # irregular in this tense unless there are no listed irregularities.
        not @irregularities[tense.to_sym].nil?
      else
        # But if we're not talking about a specific tense, it's good enough
        # to simply know whether or not there are any irregularities at all.
        true
      end
    end
  end
end
