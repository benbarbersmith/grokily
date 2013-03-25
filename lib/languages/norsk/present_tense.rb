# encoding: UTF-8

class NorskPresentTense < Tense
  @keys = "present", "presens"

  def self.regular_conjugation verb
    if verb.infinitive.end_with? "s"
      "#{verb.infinitive}"
    elsif verb.infinitive.end_with? "transitive)"
      inf = verb.infinitive.split(" ")
      "#{inf.first}r #{inf.last}"
    else
      "#{verb.infinitive}r"
    end
  end
 end
