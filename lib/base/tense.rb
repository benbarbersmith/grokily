# encoding: UTF-8

class Tense

  private

  def self.to_sym
    @keys[0].to_sym
  end
  
  public

  def self.register language
    @keys.each {|key| language.register_tense(key, self) }
  end

  def self.regular_conjugation verb
    if verb.qualified?
      verb.conjugate_with_qualifier self
    else
      self.specific_conjugation verb
    end
  end

end
