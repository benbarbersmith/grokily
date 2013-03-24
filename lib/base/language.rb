# encoding: UTF-8
require_relative 'tense'

class Language
  private

  def initialize
    @verbs = {}
    load_verbs
    @tenses = {}
    load_tenses 
  end

  public

  def register_tense(key, tense)
    @tenses[key] = tense
  end

  def verbs
    {:regular_verbs   => @verbs.values.select {|v| v if v.regular? },
     :irregular_verbs => @verbs.values.select {|v| v unless v.regular? } }
  end

  def conjugate(verb, tense, subject=false)
    @tenses[tense].conjugate(@verbs[verb])if has_verb? verb and has_tense? tense 
  end

  private

  def load_verbs 
  end

  def load_tenses
    Dir[File.dirname(__FILE__) + "/*_tense.rb"].each {|file|
      require file
      tense = /#{File.dirname(__FILE__)}\/(.*)_tense.rb/.match(file)[1]
      classname = "#{self.class}#{tense.capitalize}Tense"
      Object.const_get(classname).register(self)
    }
  end

  def has_tense? tense
    @tenses.key? tense or raise TenseException, "Unknown tense #{tense}"
  end

  def has_verb? verb
    @verbs.key? verb or raise VerbException, "Unknown verb #{verb}"
  end

  def has_subject? subject
    @subjects.map {|s| s.upcase }.include? subject.upcase  or raise SubjectException, "Unknown subject #{subject}"
  end

end

class LanguageException < Exception
end

class VerbException < LanguageException
end

class TenseException < LanguageException
end

class SubjectException < LanguageException
end
