require_relative 'modules/instance_counter.rb'
require_relative 'modules/validation.rb'
require_relative 'station'

class Route
  include InstanceCounter
  include Validation

  attr_reader :stations_list

  validate :first_station, :type, Station
  validate :last_station, :type, Station

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @mid_stations_list = []
    validate!
    self.register_instance
  end

  def stations_list
    [@first_station] + @mid_stations_list + [@last_station]
  end

  def add_station(station)
    @mid_stations_list << station
  end

  def delete_station(station)
    @mid_stations_list.delete(station)
  end

  def valid?
    validate!
    true
  rescue
    false
  end
end