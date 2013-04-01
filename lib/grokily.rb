# encoding: utf-8

require 'sinatra'
require 'json'
require_relative 'router'

def process(format, qualifier, result)
  if format.nil? 
    content_type 'text/plain'
    result.map { |r| r.to_s }.join(", ")
  elsif format == "json"
    content_type 'application/json'
    result = { qualifier => result.map do |r| 
      if r.methods.include? :to_hash then r.to_hash else r end
    end }
    JSON.pretty_generate(result)
  else
    halt 404
  end
end

router = Router.new

# Not using the webapp? Just redirect to Github.
get '/' do
  redirect 'https://github.com/benjaminasmith/grokily'
end

# See which languages are available.
get '/languages.?:format?' do |format|
  process(format, "languages", router.list_languages)
end

# See which verbs are available in the specified language.
get '/:language/verbs.?:format?' do |language, format|
  begin
    process(format, "verbs", router.list_verbs(language)) 
  rescue LanguageException
    halt 404
  end
end

# See which tenses are available in the specified language.
get '/:language/tenses.?:format?' do |language, format|
  begin
    process(format, "tenses", router.list_tenses(language)) 
  rescue LanguageException
    halt 404
  end
end

# See which subjects are available in the specified language.
get '/:language/subjects.?:format?' do |language, format|
  begin
    process(format, "subjects", router.list_subjects(language)) 
  rescue LanguageException
    halt 404
  end
end

# Allow users to specify a language, verb, tense and subject.
get '/:language/:verb/:tense/:subject.?:format?' do |language, verb, tense, subject, format|
  begin
    process(format, "conjugations", 
            router.conjugate(language, verb, tense, subject) )
  rescue LanguageException, VerbException, TenseException, SubjectException
    halt 404
  end
end

# Allow users to specify a language, verb and tense.
get '/:language/:verb/:tense.?:format?' do |language, verb, tense, format|
  begin
    process(format, "conjugations", 
            router.conjugate(language, verb, tense) )
  rescue LanguageException, VerbException, TenseException, SubjectException
    halt 404
  end
end

not_found do
  "Page not found." 
end
