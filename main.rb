require 'rubygems'
require 'sinatra'
require 'pry'
require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/base'

set :sessions, true


get '/' do
  "Hello World!"
end

get '/test' do
  "From test action"
end

get '/template' do
  erb :template
end

get '/signup' do
  erb :'/signup/signup'
end