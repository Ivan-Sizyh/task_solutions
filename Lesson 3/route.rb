class Route
  attr_reader :stations_list
  def initialize(first_station, last_station)
    @stations_list = [first_station, last_station]
  end

  def add_station(station)
    @stations_list.push(@stations_list.last)
    @stations_list[@stations_list.length - 2] = station
  end

  def delete_station(station)
    @stations_list.delete(station)
  end
end