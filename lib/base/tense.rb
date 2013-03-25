# encoding: UTF-8

class Tense
  Qualifiers = ["(transitive)", "(intransitive)", "(seg)"]

  private

  def self.to_sym
    @keys[0].to_sym
  end
  
  public

  def self.register language
    @keys.each {|key| language.register_tense(key, self) }
  end

  def self.qualified? verb
    Qualifiers.any? do |qual|
      verb.infinitive.end_with? qual
    end
  end

  def self.conjugate_with_qualifier verb
    inf = verb.infinitive.split(" ")
    newverb = verb.dup
    newverb.infinitive = inf.first
    "#{regular_conjugation(newverb)} #{inf.last}"
  end
end
