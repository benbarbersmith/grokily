# encoding: UTF-8

require 'json'
require_relative 'tense'
require_relative 'verb'

class Language
  private

  def initialize file
    @verbs = {}
    @tenses = {}
    load_verbs file unless self.instance_of? Language
    load_tenses file unless self.instance_of? Language
  end

  public

  def register_tense(key, tense)
    @tenses[key] = tense
  end

  def verbs
    {
      :regular_verbs   => \
        @verbs.values.select {|v| v unless v.irregular? }.map {|v| v.to_hash},
      :irregular_verbs => \
        @verbs.values.select {|v| v if v.irregular? }.map {|v| v.to_hash} 
    }
  end

  def conjugate(verb, tense, subject=false)
    @tenses[tense].conjugate(@verbs[verb])if has_verb? verb and has_tense? tense 
  end

  private

  def load_verbs file
    if @verbs.empty? 
      verb_file = File.open(File.dirname(file) + "/verbs.json") 
      verbs = JSON.parse(verb_file.read, :symbolize_names => true) 
      verbs.each {|v| 
        verb = Verb.new(v)
        @verbs[verb.infinitive] = verb
      }
    end
  end

  def load_tenses file
    Dir[File.dirname(file) + "/*_tense.rb"].each {|file|
      require file
      tense = /#{File.dirname(file)}\/(.*)_tense.rb/.match(file)[1]
      classname = "#{self.class}#{tense.capitalize}Tense"
      Object.const_get(classname).register(self)
    } if @tenses.empty? 
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
