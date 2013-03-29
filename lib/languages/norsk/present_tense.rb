# encoding: UTF-8

class NorskPresentTense < NorskTense
  @keys = "present", "presens"

  def self.specific_conjugation(verb)
    if verb.infinitive.end_with? "s"
      "#{verb.infinitive}"
    else
      "#{verb.infinitive}r"
    end
  end
 end
