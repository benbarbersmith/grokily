# encoding: UTF-8

class Norsk < Language
  def initialize
    @cheers = "si skål!"
    @subjects = ["Jeg", "Du", "Han", "Hun", "Vi", "De", "Den", "Det", "Dere"]
    @default_subject = @subjects[0]
    @regular_verbs = []
    @irregular_verbs = ["finnes"]
    @verbs = @irregular_verbs + @regular_verbs
  end
end
