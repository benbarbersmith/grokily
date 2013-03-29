# encoding: UTF-8

class Norsk < Language
  def initialize
    @subjects = [ "jeg", "du", "han", "hun", "den", "det", "vi", "dere", "de" ]
    super __FILE__
  end
end

class NorskTense < Tense
  def self.regular_conjugation(verb, subject)
    subjectify(subject, self.specific_conjugation(verb))
  end

  def self.subjectify(subject, conjugation)
    "#{subject} #{conjugation}"
  end
end
