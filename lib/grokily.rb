# encoding: utf-8
require 'sinatra/base'
require_relative 'language'
require_relative 'router'

class Grokily < Sinatra::Base
  router = Router.new

  # Not using the API? Just redirect to Github.
  get '/' do
    redirect 'https://github.com/benjaminasmith/grokily'
  end

  # Allow users to specify a language, verb, tense and subject...
  get '/:language/:verb/:tense/:subject' do |language, verb, tense, subject|
    begin
      router.process(language, verb, tense, subject) 
    rescue LanguageException
      halt 404
    end
  end

  # ...or ignore the subject, if they prefer.
  get '/:language/:verb/:tense' do |language, verb, tense|
    begin
      router.process(language, verb, tense) or halt 404
    rescue LanguageException
      halt 404
    end
  end

  not_found do
    "Whoops. Not found." 
  end

  run! if app_file == $0

end
