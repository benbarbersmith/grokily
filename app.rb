# encoding: utf-8
require 'sinatra'

class Grokily < Sinatra::Application

  # Not using the API? Just redirect to Github.
  get '/' do
    redirect 'https://github.com/benjaminasmith/grokily'
  end

  

end
