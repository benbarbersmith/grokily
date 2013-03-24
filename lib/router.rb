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
    lang = @languages[language] or raise LanguageException, "Language #{language} not found." 
    lang.verbs
  end

  # Process a user inputs by conjugating the verb and applying a subject.
  def conjugate_verb(language, verb, tense)
    lang = @languages[language] or raise LanguageException, "Language #{language} not found." 
    lang.conjugate(verb, tense)
  end

end

