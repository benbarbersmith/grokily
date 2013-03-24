# encoding: UTF-8

class NorskPresentTense < Tense
  @keys = "present", "presens"

  def self.regular_conjugation verb
    if verb.infinitive.end_with? "s"
      "#{verb.infinitive}"
    else
      "#{verb.infinitive}r"
    end
  end
 end
