# encoding: utf-8
require 'sinatra/base'
require 'json'
require_relative 'base/language'
require_relative 'router'

class Grokily < Sinatra::Base
  router = Router.new

  before do
    content_type 'text/plain'
  end

  # Not using the API? Just redirect to Github.
  get '/' do
    redirect 'https://github.com/benjaminasmith/grokily'
  end

  # See which languages are available.
  get '/languages.?:format?' do
    if params[:format] == "json"
      content_type 'application/json'
      {"languages" => router.languages}.to_json
    elsif params[:format].nil? 
      "languages: " + router.languages.join(", ")
    else
      halt 404
    end
  end

  # See which verbs are available in the specified language.
  get '/:language/verbs.?:format?' do |language, format|
    verbs = router.list_verbs(language)
    if format.nil? 
      "regular verbs: " + \
      verbs[:regular_verbs].map {|v| v["infinitive"] }.join(", ") + \
      "\n\n" + \
      "irregular verbs: " + \
      verbs[:irregular_verbs].map {|v| v["infinitive"] }.join(", ")
    elsif format == "json"
      content_type 'application/json'
      verbs.to_json
    else
      halt 404
    end
  end
  
  # Allow users to specify a language, verb and tense.
  get '/:language/:verb/:tense.?:json?' do |language, verb, tense, format|
    begin 
      conjugations = router.conjugate_verb(language, verb, tense) or halt 404
    rescue LanguageException
      halt 404
    end
    if format.nil? 
      conjugations.join(" / ")
    elsif format == "json"
      content_type 'application/json'
      conjugations.map {|c| c.to_hash }.to_json
    else
      halt 404
    end

  end
 
  not_found do
    "Page not found." 
  end

  run! if app_file == $0

end
