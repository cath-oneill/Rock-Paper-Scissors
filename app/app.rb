require 'sinatra'
require_relative 'lib/puppy-breeder.rb'

get '/' do
  erb :index
end