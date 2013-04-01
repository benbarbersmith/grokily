# encoding: UTF-8

class Conjugation
  attr_accessor :verb, :conjugations

  def initialize(verb, conjugations, tense, subject, translate = false)
    @verb = verb
    @conjugations = [conjugations].flatten
    @tense = tense
    @subject = subject unless subject.nil?
    @use_translation = translate
  end

  def to_s
    qualified_conjugations.join(", ")
  end

  def to_hash
    hash = { :verb => verb.to_s, 
             :english => verb.english.to_s,
             :conjugation => conjugations,
             :tense => @tense.to_sym }
    hash[:subject] = @subject if instance_variables.include? :@subject
    hash[:qualifier] = verb.qualifier if verb.qualified?
    hash
  end 

  def translate
    Conjugation.new(@verb, @conjugations, @tense, @subject, true)
  end

  private

  def qualifiers
    qualifiers = []
    qualifiers << verb.qualifier if verb.qualified?
    qualifiers << verb.english if @use_translation
    qualifiers 
  end

  def qualified_conjugations
    if qualifiers.empty? 
      @conjugations
    else
      @conjugations.map { |c| "#{c} (#{qualifiers.join(", ")})" }
    end
  end

end
