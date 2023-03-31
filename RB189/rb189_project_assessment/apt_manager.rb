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
  rent_cost == rent_cost.to_i.to_s && rent_cost.to_f < 10000.00 && rent_cost.to_i > 0
end

def user_signed_in?
  session.key?(:username)
end

def require_signed_in_user
  unless user_signed_in?
    session[:error] = "You must be signed in to do that."
    redirect "/signin"
  end
end

helpers do
  def final_page(collection_size, offset_size)
    remainder = collection_size % offset_size
    final_page_count = collection_size / offset_size + remainder - 1
  end
end


before do
  @storage = DatabasePersistence.new(logger)
end

# Display all apartment buildings
get '/' do
  require_signed_in_user
  redirect '/signin'
end

get '/signin' do
  erb :signin
end

post '/signin' do 
  if params[:username] == 'grader' && params[:password] == '100%'
    session[:username] = params[:username]
    session[:success] = 'Welcome!'
    redirect '/apartments?page_count=0'
  else
    session[:error] = 'Invalid Credentials.'
    status 422
    erb :signin
  end
end

post '/signout' do
  session[:success] = 'You have signed out'
  session.delete(:username)
  redirect '/signin'
end

# Display all apartment buildings
get '/apartments' do
  require_signed_in_user
  @apartment_id = params[:apt_id].to_i
  @apartment_count =  @storage.count_apartments
  
  if params[:page_count].to_i <= final_page(@apartment_count, 2) && params[:page_count].to_i >= 0 || @apartment_count == 0
    page_incrementation = params[:page_count].to_i * 2
  else
    session[:error] = "Page number #{params[:page_count]} does not exist."
    redirect "/apartments?page_count=0"
  end
  @apartments = @storage.all_apartments(page_incrementation)
  erb :apartments
end

# Go to page that allows the creation of a new apartment building
get '/apartments/new' do
  require_signed_in_user
  erb :new_apartment
end

# Post form to add a new apartment building to apartment page
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

# Display all tenants in a particular apartment building
get '/apartments/:apt_id' do
  require_signed_in_user
  @apartment_id = params[:apt_id].to_i
  @tenant_count =  @storage.count_units_in_apartment(@apartment_id)
  if params[:page_count].to_i <= final_page(@tenant_count, 2) && params[:page_count].to_i >= 0 || @tenant_count == 0
    page_incrementation = params[:page_count].to_i * 2
  else
    session[:error] = "Page number #{params[:page_count]} does not exist."
    redirect "/apartments/#{@apartment_id}?page_count=0"
  end
  @units = @storage.units_in_apartment(@apartment_id, page_incrementation)
  
  erb :apartment
end

# Go to page that allows for the updating of a specific apartment building
get '/apartments/:apt_id/update' do
  require_signed_in_user
  @apt_id = params[:apt_id]
  erb :edit_apartment
end

# Update the information of an existing apartment building
post '/apartments/:apt_id/update' do
  apt_id = params[:apt_id]
  apt_name = params[:apartment_name]
  apt_address = params[:apartment_address]
  
  if valid_name?(apt_name) && valid_address?(apt_address)
    @storage.update_apartment_info(apt_id, apt_name, apt_address)
    session[:success] = 'Apartment has been updated'
    redirect '/apartments'
  else
    session[:error] = 'Invalid apartment name or address'
    erb :edit_apartment
  end
end

# Delete an apartment building
get '/apartments/:apt_id/delete' do
  require_signed_in_user
  apt_id = params[:apt_id]
  apt_name = @storage.find_apartment(apt_id)[0][:name]
  
  @storage.delete_apartment(apt_id)
  session[:success] = "#{apt_name} has been removed."
  redirect '/apartments?page_count=0'
end
  

# Delete a specific tenant in an apartment building
get '/apartments/:apt_id/tenant/:tenant_id/delete' do
  require_signed_in_user
  tenant_id = params[:tenant_id]
  apt_id = params[:apt_id]
  tenant_name = @storage.find_tenant(tenant_id)[0][:tenant]
  
  @storage.delete_tenant(tenant_id)
  session[:success] = "Tenant #{tenant_name} has been removed."
  redirect "/apartments/#{apt_id}?page_count=0"
end

# Go to the page that allows for the update of the values for a particular tenant in a building
get '/apartments/:apt_id/tenant/:tenant_id/update' do
  require_signed_in_user
  @tenant_id = params[:tenant_id]
  erb :edit_unit
end

# Update the information of a particular tenant in an apartment building
post '/apartments/:apt_id/tenant/:tenant_id/update' do
  apt_id = params[:apt_id]
  @tenant_id = params[:tenant_id]
  tenant_name = params[:tenant_name]
  unit_rent = params[:unit_rent]
  
  if valid_tenant_name?(tenant_name) && valid_rent?(unit_rent)
    @storage.update_unit_info(@tenant_id, tenant_name, unit_rent)
    session[:success] = 'Tenant information has been updated'
    redirect "/apartments/#{apt_id}"
  else
    session[:error] = 'Invalid tenant name or rent'
    erb :edit_unit
  end
end

# Go to the page that allows for the addition of a new tenant to a building
get '/apartments/:apt_id/new_tenant' do
  require_signed_in_user
  @apartment_id = params[:apt_id].to_i
  
  erb :new_tenant
end

# Add a new tenant to a building
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