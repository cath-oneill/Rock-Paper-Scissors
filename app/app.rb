require 'sinatra'
require 'rack-flash'
require_relative 'lib/rps.rb'

set :sessions, true
use Rack::Flash

get '/' do
  if session['sesh_example']
    @user = Sesh.dbi.get_user_by_username(session['sesh_example'])
    erb :index
  else #not in session
    erb :signin
  
end

get '/signin' do
  erb :signin
end

get '/signup' do
  if session['sesh_example']
    redirect to '/'
  else
    erb :signup
  end
end

post '/signup' do
  sign_up = Sesh::SignUp.run(params)

  if sign_up[:success?]
    session['sesh_example'] = sign_up[:session_id]
    redirect to '/'
  else
    flash[:alert] = sign_up[:error]
    redirect to '/sign_up'
  end
end

post '/signin' do
  sign_in = Sesh::SignIn.run(params)

  if sign_in[:success?]
    session['sesh_example'] = sign_in[:session_id]
    redirect to '/'
  else
    flash[:alert] = sign_in[:error]
    redirect to '/signin'
  end
end

get '/signout' do
  session.clear
  redirect to '/'
end

get '/play/:match_id' do
  #check for current round and get out of db or create
  @current_round = #access database stuff
  erb :play
end

post '/play/:match_id/:move' do
  #save that stuff in the db

end

get '/players' do
  @all_users = [{user_id: 1, name: "Bob"}]
  erb :players
end

get '/newmatch/:user_id' do
  #create a new match (@user and our user_id that was just passed)
  #stick in DB
  #get back out and recreate

  redirect '/play/:match_id'
end

get '/stats' do
  #get all matches and all rounds out of db
  erb :stats
end

get '/editprofile' do

end





