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
  erb :apartments
end