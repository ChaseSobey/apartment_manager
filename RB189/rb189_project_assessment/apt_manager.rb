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

def valid_name?(name)
  name.strip.length > 0
end

def valid_address?(address)
  address[0] == address[0].to_i.to_s && address.strip.length > 0
end

def valid_tenant_name?(name)
  name.strip.size > 0 && name.split.size > 1
end

def valid_rent?(rent_cost)
  rent_cost == rent_cost.to_i.to_s
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

post '/apartments' do
  apt_name = params[:apartment_name]
  apt_address = params[:apartment_address]
  
  if valid_name?(apt_name) && valid_address?(apt_address)
    @storage.add_new_apartment(apt_name, apt_address)
    session[:success] = 'A new apartment has been added'
    redirect '/apartments'
  else
    session[:error] = 'Invalid apartment name or address'
    erb :new_apartment
  end
end

get '/apartments/:apt_id' do
  @apartment_id = params[:apt_id].to_i
  @units = @storage.units_in_apartment(@apartment_id)
  
  erb :apartment
end

get '/apartments/:apt_id/delete' do
  apt_id = params[:apt_id]
  apt_name = @storage.find_apartment(apt_id)[0][:name]
  
  @storage.delete_apartment(apt_id)
  session[:success] = "#{apt_name} has been removed."
  redirect '/apartments'
end
  

get '/apartments/:apt_id/tenant/:tenant_id/delete' do
  tenant_id = params[:tenant_id]
  apt_id = params[:apt_id]
  tenant_name = @storage.find_tenant(tenant_id)[0][:tenant]
  
  @storage.delete_tenant(tenant_id)
  session[:success] = "Tenant #{tenant_name} has been removed."
  redirect "/apartments/#{apt_id}"
end

get '/apartments/:apt_id/new_tenant' do
  @apartment_id = params[:apt_id].to_i
  
  erb :new_tenant
end

post '/apartments/:apt_id' do
  @apartment_id = params[:apt_id]
  tenant = params[:tenant_name]
  rent = params[:unit_rent]
  
  if valid_tenant_name?(tenant) && valid_rent?(rent)
    @storage.add_new_tenant(tenant, rent, @apartment_id)
    session[:success] = "#{tenant} has been added as a tenant."
    redirect "/apartments/#{@apartment_id}"
  else
    session[:error] = 'Invalid tenant name or rent'
    erb :new_tenant
  end
end