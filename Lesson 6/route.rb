require_relative 'modules/instance_counter.rb'
require_relative 'modules/validation_method.rb'

class Route
  include InstanceCounter
  include Validate

  attr_reader :stations_list
  def initialize(first_station, last_station)
    @stations_list = [first_station, last_station]
    validate!
    self.register_instance
  end

  def add_station(station)
    @stations_list.push(@stations_list.last)
    @stations_list[@stations_list.length - 2] = station
  end

  def delete_station(station)
    @stations_list.delete(station)
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  protected

  def validate!
    raise "Начальные и конечные станции должны существовать!" if @stations_list.first.class != Station || @stations_list.last.class != Station
  end
end