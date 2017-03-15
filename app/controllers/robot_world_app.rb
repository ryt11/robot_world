require_relative '../models/robot.rb'


class RobotWorldApp < Sinatra::Base
  set :root, File.expand_path("..", __dir__)
  set :method_override, true

  get '/robots' do
    Robot.database
    @robots = Robot.all
    erb :index
  end

  get '/robots/new' do
    erb :new
  end

  post '/robots' do
     robot = Robot.new(params['robot'])
     robot.save
     redirect '/robots'
  end

  get '/robots/:id/edit' do
    @robot = Robot.find(params[:id])
    erb :edit

  end

  get '/robots/:id/delete' do |id|
    Robot.disintegrate(id.to_i)
    redirect '/robots'
  end

  get '/robots/:id' do
    @robot = Robot.find(params[:id])
    erb :show
  end

  put '/robots/:id' do |id|
    Robot.update(id.to_i, params[:robot])
    redirect "/robots/#{id}"
  end

  get '/dashboard' do
    @robots = Robot.all
    @dep_stats = Robot.stats("department")
    @state_stats = Robot.stats("state")
    @city_stats = Robot.stats("city")
    erb :dashboard
  end

end
