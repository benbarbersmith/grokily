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

  # Process a user inputs by conjugating the verb and applying a subject.
  def process(language, verb, tense, subject=false)
    lang = @languages[language] or raise LanguageException, "Language #{language} not found." 
    lang.conjugate(verb, tense, subject)
  end

end

