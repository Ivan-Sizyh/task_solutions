require_relative 'modules/instance_counter.rb'

class Route
  include InstanceCounter

  attr_reader :stations_list
  def initialize(first_station, last_station)
    @stations_list = [first_station, last_station]
    self.register_instance
  end

  def add_station(station)
    @stations_list.push(@stations_list.last)
    @stations_list[@stations_list.length - 2] = station
  end

  def delete_station(station)
    @stations_list.delete(station)
  end
end