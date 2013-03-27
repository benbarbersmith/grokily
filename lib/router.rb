# encoding: utf-8

class Router
  attr_reader :languages

  def initialize
    @languages = {}
    Dir[File.dirname(__FILE__) + "/languages/*/language.rb"].each {|file| 
      require file
      lang = /languages\/(.*)\/language\.rb/.match(file)[1]
      @languages[lang] = Object.const_get(lang.capitalize).new
    }
  end

  public 

  # Return a list of languages available.
  def languages
    @languages.keys
  end

  # Return a list of verbs available for a given language.
  def list_verbs(language)
    @languages[language].verbs or \
      raise LanguageException, "Language #{language} not found." 
  end

  # Return a list of tenses available for a given language.
  def list_tenses(language)
    @languages[language].tenses or \
      raise LanguageException, "Language #{language} not found." 
  end

  # Process a user inputs by conjugating the verb and applying a subject.
  def conjugate_verb(language, verb, tense)
    @languages[language].conjugate(verb, tense) or \
      raise LanguageException, "Language #{language} not found." 
  end

end

