# encoding: UTF-8

class Norsk < Language

  def initialize
    @subjects = ["Jeg", "Du", "Han", "Hun", "Vi", "De", "Den", "Det", "Dere"]
    @tenses = {}
    @verbs =  {"få" => "få"}

    NorskPresentTense.register(self)
  end

  def conjugate(verb, tense, subject=false)
    if has_verb? verb and has_tense? tense 
      @tenses[tense].conjugate(@verbs[verb])
    end
  end
end

class NorskPresentTense < Tense
  @keys = "present", "presens"

  def self.conjugate verb
    "#{verb}r" 
  end
end
