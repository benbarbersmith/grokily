# encoding: utf-8
require 'sinatra/base'
require_relative 'base/language'
require_relative 'router'

class Grokily < Sinatra::Base
  router = Router.new

  # Not using the API? Just redirect to Github.
  get '/' do
    redirect 'https://github.com/benjaminasmith/grokily'
  end

  # Allow users to specify a language, verb and tense.
  get '/:language/:verb/:tense' do |language, verb, tense|
    begin 
      router.conjugate_verb(language, verb, tense) or halt 404
    rescue LanguageException
      halt 404
    end
  end

  not_found do
    "Page not found." 
  end

  run! if app_file == $0

end
