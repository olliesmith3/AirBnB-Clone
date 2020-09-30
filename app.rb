require 'sinatra/base'
require './lib/space.rb'
require './lib/database_connection.rb'
require './lib/user'
require './lib/request'
require 'sinatra/flash'
require './database_connection_setup'
require './lib/dashboard'


class Airbnb < Sinatra::Base

  enable :sessions, :method_override
  register Sinatra::Flash

  get '/' do
    @spaces = Dashboard.all
    erb (:view_index)
  end

  get '/spaces' do
    @current_user = User.instance
    @spaces = Dashboard.all
    erb :spaces
  end

  get '/spaces/new' do
    erb :new_space
  end

  post '/spaces/new' do
    @current_user = User.instance
    Space.create(@current_user.id, params[:description], params[:price])
    redirect '/spaces'
  end

  post '/signup' do
    if (!User.duplicated_username?(params[:username]) && User.unique_email?(params[:email]))
      User.store(params[:password], params[:username], params[:username])
      redirect '/dashboard'
    else
      flash[:already_signed_up] = "Username or email is taken"
      redirect '/'
    end
  end

  post '/login' do
    if User.authenticate?(params[:login_username], params[:login_password])
      @current_user = User.create(params[:login_username])
      @current_user = User.instance
      redirect '/spaces'
    else 
      flash[:incorrect_login] = "Login details incorrect"
      redirect '/'
    end
  end

  post '/sessions/logout' do
    User.log_out
    flash[:logout]= "You have logged out"
    redirect '/'
  end

  get '/requests' do
    @current_user = User.instance
    @requests = Request.my_requests(@current_user.id)
    erb :requests
  end

  get '/dashboard' do
    erb :dashboard
  end

  get '/request/:id/new' do
    erb :new_request
  end

end