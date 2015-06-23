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

  def card_image(card) # takes ['H', '5'] ; needs to return string <img src='public/images/cards/hearts_5.jpg'>
  suit = case card[0]
  when 'H' then 'hearts'
  when 'D' then 'diamonds'
  when 'C' then 'clubs'
  when 'S' then 'spades'
  end

  if ['J', 'Q', 'K', 'A'].include?(card[1])
    value = case card[1]
    when 'J' then 'jack'
    when 'Q' then 'queen'
    when 'K' then 'king'
    when 'A' then 'ace'
    end
  else
    value = card[1]
  end
  "<img src='/images/cards/#{suit}_#{value}.jpg'>"
  end

  def winner!(msg)
    @success = "#{session[:player_name]} wins!"
    @show_dealer_cards = true
    @show_buttons = false
    @play_again = true
    session[:player_money] += session[:player_bet].to_i
    erb :game
  end

  def loser!(msg)
    @error = "Dealer wins!"
    @show_dealer_cards = true
    @show_buttons = false
    @play_again = true
    session[:player_money] -= session[:player_bet].to_i
    erb :game
  end

  def tie!(msg)
    @success = "It was a tie!"
    @show_dealer_cards = true
    @show_buttons = false
    @play_again = true
    erb :game
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

get '/gameover' do
  erb :game_over
end

get '/new_player' do
  session[:player_money] = 500
  erb :new_player
end

post "/new_player" do
  if params[:player_name].empty?
    @error = "Name is required."
    erb :new_player
  else
  session[:player_name] = params[:player_name].capitalize
  erb :bet
  end
end

before do
  @show_buttons = true
  @show_dealer_button = false
  @show_dealer_cards = false
  @play_again = false
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

get '/bet' do
  erb :bet
end

post '/bet' do
session[:player_bet] = params[:player_bet]
player_bet = session[:player_bet].to_i
  if player_bet > session[:player_money]
    @bet_error = "Your bet can't be more than you have!"
    erb :bet
  elsif player_bet == 0 
    @bet_error = 'Your bet must be a non-zero integer!'
    erb :bet
  else
    redirect '/game'
  end
end

get '/dealer_turn' do
  @show_buttons = false
  dealer_total = calculate_total(session[:dealer_cards])
  if dealer_total == 21
    redirect '/compare'
  elsif dealer_total > 21
    winner!('msg')
  elsif dealer_total <= 17
    @success = "The dealer chose to hit."
    @show_dealer_button = true
  else
    @success = "The dealer chose to stay."
    redirect '/compare'
  end
  erb :game
end

get '/compare' do
  
  dealer_total = calculate_total(session[:dealer_cards])
  player_total = calculate_total(session[:player_cards])

  if player_total > dealer_total
    winner!('msg')
  elsif dealer_total > player_total
    loser!('msg')
  elsif dealer_total == player_total
    tie!('msg')
  end
  erb :game
end

post '/dealer/hit' do
  session[:dealer_cards] << session[:deck].pop
  redirect '/dealer_turn'
  erb :game, layout: false
end

post '/game/player/hit' do
  session[:player_cards] << session[:deck].pop
  player_total = calculate_total(session[:player_cards])
  if player_total == 21
    winner!('msg')
  elsif player_total > 21
    loser!('msg')
  else
    erb :game, layout: false
  end
  # check if player busted
  # if bust, game over
end

