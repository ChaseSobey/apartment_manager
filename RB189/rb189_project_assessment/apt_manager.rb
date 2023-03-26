require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubis"
require 'pg'

get '/' do
  erb :apartments
end