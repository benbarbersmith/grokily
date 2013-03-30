# encoding: UTF-8

class Conjugation
  attr_accessor :verb

  def initialize(verb, conjugation, tense, subject, translate = false)
    @verb = verb
    @conjugation = [conjugation].flatten
    @tense = tense
    @subject = subject unless subject.nil?
    @use_translation = translate
  end

  def to_s
    qualified_conjugation.join(", ")
  end

  def to_hash
    hash = { :verb => verb.to_s, 
             :conjugation => qualified_conjugation,
             :tense => @tense.to_sym }
    hash[:subject] = @subject if instance_variables.include? :@subject
    hash
  end 

  def translate
    Conjugation.new(@verb, @conjugation, @tense, @subject, true)
  end

  private

  def qualifiers
    qualifiers = []
    qualifiers << verb.qualifier if verb.qualified?
    qualifiers << verb.english if @use_translation
    qualifiers 
  end

  def qualified_conjugation 
    if qualifiers.empty? 
      @conjugation
    else
      @conjugation.map(&:join(", "))
    end
  end

end
