# encoding: UTF-8

require 'unicode'

class NorskImperativeTense < NorskTense
  @keys = "imperative", "viktig"

  def self.specific_conjugation(verb)
    # Use the Unicode module to ensure letters like ø are capitalized.
    "#{Unicode::capitalize(NorskStemTense.regular_conjugation(verb))}!"
  end
 end
