require 'rubygems'
require 'sinatra'
require 'pry'
require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/base'

set :sessions, true


get '/' do
  # This should validate that a username is set
  # If a username is not set, then redirect to a form to set the username
  if session[:player_name]
    redirect "/game"
  else
    redirect "/new_player"
  end
end

get "/new_player" do
  erb :new_player
end

post "/new_player" do
  session[:player_name] = params[:player_name]
  redirect "/game"
end

get "/game" do
  suits = ['C', 'H', 'D', 'S']
  values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  session[:deck] = suits.product(values).shuffle!

  session[:player_cards] = []
  session[:dealer_cards] = []

  2.times do
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  end

  # set up initial values
  # render the template
  # add redirect back to '/' if no player name exists
  erb :game
end