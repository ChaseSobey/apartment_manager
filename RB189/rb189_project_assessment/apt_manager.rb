require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubis"

require_relative "database_persistence.rb"

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do
  @storage = DatabasePersistence.new(logger)
end

get '/' do
  @apartments = @storage.all_apartments
  erb :apartments
end

get '/apartment/:apt_id' do
  @apartment_id = params[:apt_id].to_i
  @units = @storage.units_in_apartment(@apartment_id)
  
  erb :apartment
end