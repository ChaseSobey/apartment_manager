require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubis"

require_relative "database_persistence.rb"

configure do
  enable :sessions
  set :session_secret, 'secret'
  set :erb, :escape_html => true
end

before do
  @storage = DatabasePersistence.new(logger)
end

get '/' do
  redirect '/apartments'
end

get '/apartments' do
  @apartments = @storage.all_apartments
  erb :apartments
end

get '/apartments/new' do
  erb :new_apartment
end

get '/apartments/:apt_id' do
  @apartment_id = params[:apt_id].to_i
  @units = @storage.units_in_apartment(@apartment_id)
  
  erb :apartment
end

get '/apartments/:apt_id/new_tenant' do
  @apartment_id = params[:apt_id].to_i
  
  erb :new_tenant
end