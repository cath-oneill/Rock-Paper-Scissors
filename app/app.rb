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
    redirect to '/players'
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
    flash.now[:alert] = sign_up[:error]
    redirect to '/sign_up'
  end
end

post '/signin' do
  sign_in = RPS::SignIn.run(params)

  if sign_in[:success?]
    session['rps'] = sign_in[:session_id]
    redirect to '/'
  else
    flash.now[:alert] = sign_in[:error]
    redirect to '/signin'
  end
end

get '/signout' do
  session.clear
  redirect to '/signin'
end

get '/play/:match_id/:round_id' do
  @user = RPS::DBI.dbi.get_user_by_id(session['rps'])
  @game_info = {
    match_id: params['match_id'],
    round_id: params['round_id']
  }
  @history = RPS::MatchHistory.run(session['rps'], params['match_id'])
  erb :play
end

get '/view/:match_id' do
  @user = RPS::DBI.dbi.get_user_by_id(session['rps'])
  @history = RPS::MatchHistory.run(session['rps'], params['match_id'])
  @opponent = RPS::GetOpponent.run(session['rps'], params['match_id'])
  erb :view
end

post '/play/:match_id/:round_id/:move' do
  @user = RPS::DBI.dbi.get_user_by_id(session['rps'])
  @feedback = RPS::RecordMove.run(session['rps'], params['match_id'], params['round_id'], params['move'])
  @match_id = params['match_id']
  erb :feedback
end

get '/players' do
  @user = RPS::DBI.dbi.get_user_by_id(session['rps'])
  @all_users = RPS::DBI.dbi.get_all_profile_info
  erb :players
end

get '/newmatch/:opponent_id' do
  @game_info = RPS::CreateNewMatch.run(session['rps'], params['opponent_id'])
  @user = RPS::DBI.dbi.get_user_by_id(session['rps'])
  @history = RPS::MatchHistory.run(session['rps'], @game_info[:match_id])
  erb :play
end


get '/stats' do
  @user = RPS::GetUserInfo.run(session['rps'])
  @match_info = RPS::GetMatchInfo.run(@user)
  erb :stats
end

get '/editprofile' do
  @user = RPS::DBI.dbi.get_user_by_id(session['rps'])
  erb :editprofile
end

post '/editpassword' do
  @user = RPS::DBI.dbi.get_user_by_id(session['rps'])
  password_response = RPS::EditPassword.run(params, @user)
  flash.now[:alert] = password_response[:message]
  redirect to '/editprofile'
end




