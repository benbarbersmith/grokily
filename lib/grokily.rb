# encoding: utf-8
require 'sinatra/base'
require 'json'
require_relative 'base/language'
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

class Grokily < Sinatra::Base
  router = Router.new

  # Not using the API? Just redirect to Github.
  get '/' do
    redirect 'https://github.com/benjaminasmith/grokily'
  end

  # See which languages are available.
  get '/languages.?:format?' do |format|
    process(format, "languages", router.languages)
  end

  # See which verbs are available in the specified language.
  get '/:language/verbs.?:format?' do |language, format|
    process(format, "verbs", router.list_verbs(language)) 
  end
  
  # See which tenses are available in the specified language.
  get '/:language/tenses.?:format?' do |language, format|
    process(format, "tenses", router.list_tenses(language)) 
  end

  # Allow users to specify a language, verb and tense.
  get '/:language/:verb/:tense.?:format?' do |language, verb, tense, format|
    begin
      process(format, "conjugations", \
              router.conjugate_verb(language, verb, tense)) 
    rescue VerbException
      halt 404
    end
  end
 
  not_found do
    "Page not found." 
  end

  run! if app_file == $0

end
