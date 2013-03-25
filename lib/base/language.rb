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

  def load_verbs file
    if @verbs.empty? 
      verb_file = File.open(File.dirname(file) + "/verbs.json") 
      verbs = JSON.parse(verb_file.read, :symbolize_names => true) 
      verbs.each do |v| 
        verb = Verb.new(v)
        @verbs[verb.infinitive] = verb
      end
    end
    verbs
  end

  def load_tenses file
    if @tenses.empty?
      Dir[File.dirname(file) + "/*_tense.rb"].each do |file|
        require file
        tense = /#{File.dirname(file)}\/(.*)_tense.rb/.match(file)[1]
        classname = "#{self.class}#{tense.capitalize}Tense"
        Object.const_get(classname).register(self)
      end
    end 
  end

  public

  def register_tense(key, tense)
    @tenses[key] = tense
  end

  def verbs
    {
      :regular_verbs   => \
        (@verbs.values.select do |verb| 
          verb unless verb.irregular? 
        end).map {|verb| verb.to_hash},
      :irregular_verbs => \
        (@verbs.values.select do |verb| 
          verb if verb.irregular? 
        end).map {|verb| verb.to_hash} 
    }
  end

  def conjugate(verb, tense, subject=false)
    if has_verb? verb and has_tense? tense 
      @verbs[verb].conjugate(@tenses[tense]) 
    end
  end

  private

  def has_tense? tense
    unless @tenses.key? tense 
      raise TenseException, "Unknown tense #{tense}"
    end
  end

  def has_verb? verb
    unless @verbs.key? verb 
      raise VerbException, "Unknown verb #{verb}"
    end
  end

  def has_subject? subject
    unless @subjects.any? {|s| s.upcase == subject.upcase } 
      raise SubjectException, "Unknown subject #{subject}"
    end
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
