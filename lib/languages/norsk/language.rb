# encoding: UTF-8

class Norsk < Language
  def initialize
    @subjects = ["Jeg", "Du", "Han", "Hun", "Vi", "De", "Den", "Det", "Dere"]
    super __FILE__
  end
end
