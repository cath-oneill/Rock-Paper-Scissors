require 'sinatra'
require 'rack-flash'
require_relative 'lib/rps.rb'

set :sessions, true
set :bind, '0.0.0.0'
use Rack::Flash

get '/' do
  if session['rps']
    @user = RPS::GetUserInfo.run(session['rps'])
    @match_info = RPS::GetMatchInfo.run(@user)
    p @user
    p @match_info
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

get '/play/:match_id/:round_id' do
  @user = RPS::GetUserInfo.run(session['rps'])
  @game_info = {
    match_id: params['match_id'],
    round_id: params['round_id']
  }
  erb :play
end

post '/play/:match_id/:round_id/:move' do
  @feedback = RPS::RecordMove.run(session['rps'], params['match_id'], params['round_id'], params['move'])
  erb :feedback
end

get '/players' do
  @all_users = [{user_id: 1, name: "Bob"}]
  erb :players
end

get '/newmatch/:opponent_id' do
  @game_info = RPS::CreateNewMatch.run(session['rps'], params['opponent_id'])
  @user = RPS::GetUserInfo.run(session['rps'])
  erb :play
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




