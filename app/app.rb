require 'sinatra'
require_relative 'lib/rps.rb'

get '/' do
  erb :index
end

get '/landing' do
