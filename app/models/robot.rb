require 'sqlite3'
require 'pry'

class Robot
  attr_reader :robot_params, :id
  def initialize(robot_params)
    @robot_params = robot_params
    @database = SQLite3::Database.new('db/robot_world_development.db')
    @database.results_as_hash = true
    @id = robot_params["id"] if robot_params["id"]
  end

  def self.stats(section)
    robots = Robot.all
    robots.group_by(&section.to_sym)
  end


  def self.find(id)
    robot = database.execute("SELECT * FROM robots WHERE id= ?;", id).first
    Robot.new(robot)
  end

  def self.all
    robots = database.execute("SELECT * FROM robots;")
    robots.map { |robot| Robot.new(robot) }
  end

  def self.disintegrate(id)
    database.execute("DELETE FROM robots WHERE id = ?;", id)
  end

  def self.update(id, robot_params)
      database.execute("UPDATE robots
                            SET name = ?,
                                city = ?,
                                state = ?,
                                department = ?
                                WHERE id = ?;",
                                robot_params[:name],
                                robot_params[:city],
                                robot_params[:state],
                                robot_params[:department],
                                id
                            )
  end

  def self.database
    database = SQLite3::Database.new('db/robot_world_development.db')
    database.results_as_hash = true
    database
  end

  def save
    @database.execute("INSERT INTO robots (name, city, state, department) VALUES (?, ?, ?, ?);", name, city, state, department)
  end

  def name
    robot_params['name']
  end

  def city
    robot_params['city']
  end

  def state
    robot_params['state']
  end

  def department
    robot_params['department']
  end

end
