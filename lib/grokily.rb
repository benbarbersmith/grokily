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
    router.process(language, verb, tense, subject) or halt 404
  end

  # ...or ignore the subject, if they prefer.
  get '/:language/:verb/:tense' do |language, verb, tense|
    router.process(language, verb, tense) or halt 404
  end

  run! if app_file == $0

end
