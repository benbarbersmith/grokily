# encoding: UTF-8

class Tense
  def self.register language
    @keys.each {|key| language.register_tense(key, self) }
  end
end
