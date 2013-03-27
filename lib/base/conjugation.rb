# encoding: UTF-8

class Conjugation
  attr_accessor :verb

  def initialize(verb, conjugation)
    @verb = verb
    @conjugation = [conjugation].flatten
  end

  def to_s
    @conjugation.join(" / ")
  end

  def to_hash
    { :verb => verb.to_hash, :conjugation => @conjugation }
  end 

  def qualify
    if verb.qualified?
      map_conjugations verb.qualifier
    else
      map_conjugations verb.english
    end
  end

  private

  def map_conjugations qualifier
    Conjugation.new(verb, @conjugation.map { |c| "#{c} (#{qualifier})" })
  end

end
