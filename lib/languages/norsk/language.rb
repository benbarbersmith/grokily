# encoding: UTF-8

class Norsk < Language
  def initialize
    @subjects = [ "jeg", "du", "han", "hun", "den", "det", "vi", "dere", "de" ]
    super __FILE__
  end
end

class NorskTense < Tense
  def self.requires_subject?
    false
  end

  def self.regular_conjugation(verb, subject=nil)
    subjectify(subject, self.specific_conjugation(verb))
  end

  def self.irregular_conjugation(conjugation, subject=nil)
    subjectify(subject, conjugation)
  end

  def self.subjectify(subject, conjugation)
    if subject.nil?
      conjugation
    else
      if conjugation.is_a? Array
        conjugation.map do |c|
          "#{subject} #{c}"
        end
      else
        "#{subject} #{conjugation}"
      end
    end
  end
end
