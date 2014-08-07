require 'sinatra'
require 'rack-flash'
require_relative 'lib/rps.rb'

set :sessions, true
set :bind, '0.0.0.0'
use Rack::Flash

get '/' do
  if session['rps']
    @user = RPS::GetUserInfo.run(session['rps'])
    erb :index
  else #not in session
    erb :signin
  end
end

get '/signin' do
  erb :signin
end

get '/signup' do
  if session['rps']
    redirect to '/'
  else
    erb :signup
  end
end

post '/signup' do
  sign_up = RPS::SignUp.run(params)

  if sign_up[:success?]
    session['rps'] = sign_up[:session_id]
    redirect to '/'
  else
    flash[:alert] = sign_up[:error]
    redirect to '/sign_up'
  end
end

post '/signin' do
  sign_in = RPS::SignIn.run(params)

  if sign_in[:success?]
    session['rps'] = sign_in[:session_id]
    redirect to '/'
  else
    flash[:alert] = sign_in[:error]
    redirect to '/signin'
  end
end

get '/signout' do
  session.clear
  redirect to '/signin'
end

get '/play/:user_id/:match_id/:round_id/' do
  @current_match = get_match_by_id(params['match_id'])
  @rounds = get_rounds_by_match_id(params['match_id'])
  @unfinished_round = @rounds.find_if {|r| r.round_info[:result].nil?}
  erb :play
end

post '/play/:user_id/:match_id/:round_id/:move' do
  @current_match = get_match_by_id(params['match_id'])
  @rounds = get_rounds_by_match_id(params['match_id'])
  @unfinished_round = @rounds.find_if {|r| r.round_info[:result].nil?}
  @unfinished_round.player_1_move!(params['player_1_move'])
  erb :feedback
end

get '/players' do
  @all_users = [{user_id: 1, name: "Bob"}]
  erb :players
end

get '/newmatch/:other_user_id' do
  #create a new match (@user and our user_id that was just passed)
  #stick in DB
  #get back out and recreate

  redirect '/play/:user_id/:match_id/:round_id'
end

get '/feedback/:user_id/:match_id/:round_id' do
  erb :feedback
end

get '/stats' do
  #get all matches and all rounds out of db
  erb :stats
end

get '/editprofile' do
  erb :editprofile
end

post '/updateprofile' do

end




