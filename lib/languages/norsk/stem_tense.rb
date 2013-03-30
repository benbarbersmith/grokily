# encoding: UTF-8

class NorskStemTense < NorskTense
  @keys = "stem", "demme"

  def self.specific_conjugation(verb)
    if verb.infinitive.end_with? "e" and verb.infinitive.size > 2
      verb.infinitive[0,verb.infinitive.size-1] 
    else
      verb.infinitive
    end
  end
 end
