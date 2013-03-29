# encoding: UTF-8

require 'json'
require_relative 'tense'
require_relative 'verb'
require_relative 'conjugation'

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
        if @verbs.has_key? verb.infinitive
          @verbs[verb.infinitive] << verb
        else
          @verbs[verb.infinitive] = [verb]
        end
      end
    end
    @verbs
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

  def register(router)
    router.register_language(self.class.to_s.downcase, self)
  end

  def register_tense(key, tense)
    @tenses[key] = tense
  end

  def verbs
    @verbs.values.flatten
  end

  def tenses
    @tenses.values.uniq
  end

  def subjects
    @subjects
  end

  def conjugate(verb, tense, subject)
    subject ||= @subjects[0]
    if has_verb? verb and has_tense? tense and has_subject? subject
      conjugations = @verbs[verb].map do |v| 
        v.conjugate(@tenses[tense], subject)
      end
      if any_the_same(conjugations.map(&:to_s))
        conjugations.map(&:translate)
      else
        conjugations
      end
    end
  end

  private

  def has_tense? tense
    @tenses.key? tense or 
    raise TenseException, "Unknown tense #{tense}"
  end

  def has_verb? verb
    @verbs.key? verb or 
    raise VerbException, "Unknown verb #{verb}"
  end

  def has_subject? subject 
    @subjects.include? subject.downcase or 
    raise SubjectException, "Unknown subject #{subject}"
  end

  def any_the_same array
    array.any? { |r| array.count(r) > 1 }
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
