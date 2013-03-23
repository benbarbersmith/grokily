# encoding: utf-8
require 'sinatra/base'

class Grokily < Sinatra::Base

  # Not using the API? Just redirect to Github.
  get '/' do
    redirect 'https://github.com/benjaminasmith/grokily'
  end

  run! if app_file == $0
end
