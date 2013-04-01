# encoding: UTF-8

class NorskFutureTense < NorskTense
  @keys = "future", "futurum"

  def self.specific_conjugation(verb)
    ["skal", "vil"].map { |modal| "#{modal} #{verb.infinitive}" }
  end
 end
