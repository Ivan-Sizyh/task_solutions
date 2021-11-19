class Station
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    @trains << train
  end

  def get_station_trains
    @trains
  end

  def get_cargo_trains
    @trains.filter { |train| train.type == 'грузовой' }
  end

  def get_passenger_trains
    @trains.filter { |train| train.type == 'пассажирский' }
  end

  def get_train(train)
    @trains.delete(train)
  end
end


class Route
  attr_reader :stations_list
  def initialize(first_station, last_station)
    @stations_list = [first_station, last_station]
  end

  def add_station(station_name)
    @stations_list.push(@stations_list.last)
    @stations_list[@stations_list.length - 2] = station_name
  end

  def delete_station(station_name)
    @stations_list.delete(station_name)
  end
end


class Train
  attr_reader :speed, :number_cars, :number, :type, :station, :route

  def initialize(number, type, number_cars)
    @number = number
    @type = type
    @number_cars = number_cars
    @speed = 0
  end

  def speed=(speed)
    if speed > 0
      @speed = speed
    end
  end

  def stop
    @speed = 0
  end

  def add_car
    if @speed == 0
      @number_cars += 1
    end
  end

  def remove_car
    if @speed == 0
      @number_cars -= 1
    end
  end

  def route=(route)
    if route
      @route = route
      @station = route.stations_list.first
      @station.add_train(self)
    end
  end

  def to_next_station
    if next_station
      @station.get_train(self)
      @station = next_station
      @station.add_train(self)
    end
  end

  def to_back_station
    if previous_station
      @station.get_train(self)
      @station = previous_station
      @station.add_train(self)
    end
  end

  def previous_station
    if @route
      station = @route.stations_list.index(@station)
      if station != 0
        @route.stations_list[station - 1]
      end
    end
  end

  def next_station
    if @route
      station = @route.stations_list.index(@station)
      if (station + 1) != @route.stations_list.length
        @route.stations_list[station + 1]
      end
    end
  end
end