require 'rubygems'
require 'sinatra'
require 'pry'
require 'sinatra/contrib'
require 'sinatra/reloader'
require 'sinatra/base'

set :sessions, true

helpers do
  def calculate_total(cards) #cards is a nested array
    arr = cards.map{|element| element[1]}

    total = 0
    arr.each do |a|
      if a == "A"
        total += 11
      else 
        total += a.to_i == 0 ? 10 : a.to_i
      end
    end

    #correct for aces
    arr.select{|element| element == "A"}.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end
end

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

before do
  @show_buttons = true
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

post '/game/player/stay' do
  @success = "You chose to stay. Boring."
  @show_buttons = false
  erb :game
end

post '/game/player/hit' do
  session[:player_cards] << session[:deck].pop
  if calculate_total(session[:player_cards]) > 21
    @error = "Sorry! You busted!"
    @show_buttons = false
    erb :game
  else
    erb :game
  end
  # check if player busted
  # if bust, game over
end

