# encoding: utf-8

require_relative 'base/language'

class Router
  attr_reader :languages

  def initialize
    @languages = {}
    Dir[File.dirname(__FILE__) + "/languages/*/language.rb"].each do |file| 
      require file
      lang = /#{File.dirname(__FILE__)}\/languages\/(.*)\/language.rb/.match(file)[1]
      Object.const_get(lang.capitalize).new.register(self)
    end
  end

  def register_language(key, language)
    @languages[key] = language
  end

  def get_language language
    @languages[language] or
      raise LanguageException, "Language #{language} not found." 
  end

  # Return a list of languages available.
  def list_languages
    @languages.keys
  end

  # Return a list of verbs available for a given language.
  def list_verbs(language)
    get_language(language).verbs
  end

  # Return a list of tenses available for a given language.
  def list_tenses(language)
    get_language(language).tenses
  end

  # Process a user inputs by conjugating the verb and applying a subject.
  def conjugate(language, verb, tense, subject=nil)
    get_language(language).conjugate(verb, tense, subject)
  end

end
