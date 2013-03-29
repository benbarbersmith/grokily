# encoding: UTF-8

class Conjugation
  attr_accessor :verb

  def initialize(verb, conjugation, translate = false)
    @verb = verb
    @conjugation = [conjugation].flatten
    @use_translation = translate
  end

  def to_s
    qualified_conjugation.join(", ")
  end

  def to_hash
    { :verb => verb.to_s, :conjugation => qualified_conjugation }
  end 

  def translate
    Conjugation.new(@verb, @conjugation, true)
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
      @conjugation.map { |c| "#{c} (#{qualifiers.join(", ")})" }
    end
  end

end
