# encoding: UTF-8

class NorskPresentTense < Tense
  @keys = "present", "presens"

  def self.conjugate verb
    "#{verb}r" 
  end
end
