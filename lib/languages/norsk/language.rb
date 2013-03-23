# encoding: UTF-8

class Norsk < Language
  def initialize
    @tenses = {}
    Dir[File.dirname(__FILE__) + "/*_tense.rb"].each {|file|
      require file
      tense = /#{File.dirname(__FILE__)}\/(.*)_tense.rb/.match(file)[1]
      classname = "#{self.class}#{tense.capitalize}Tense"
      Object.const_get(classname).register(self)
    }
    @subjects = ["Jeg", "Du", "Han", "Hun", "Vi", "De", "Den", "Det", "Dere"]
    @verbs =  {"få" => "få"}
  end

  def conjugate(verb, tense, subject=false)
    if has_verb? verb and has_tense? tense 
      @tenses[tense].conjugate(@verbs[verb])
    end
  end
end
