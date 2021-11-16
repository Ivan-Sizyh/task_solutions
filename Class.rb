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
    train_list = []
    @trains.each do |train|
      if train.type == "грузовой"
        train_list << train
      end
    end
    train_list
  end

  def get_passenger_trains
    train_list = []
    @trains.each do |train|
      if train.type == "пассажирский"
        train_list << train
      end
    end
    train_list
  end

  def get_train
    if @trains.length != 0
      @trains.shift
    end
  end
end


class Route
  attr_reader :stations_list, :first_station, :last_station
  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations_list = [first_station, last_station]
  end

  def add_station(station_name)
    @stations_list.push(@last_station)
    @stations_list[@stations_list.length - 2] = station_name
  end

  def delete_station(station_name)
    @stations_list.delete(station_name)
  end
end


class Train
  attr_accessor :route, :current_station, :previous_station, :next_station
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
    @route = route
    @station = route.first_station
  end

  def to_next_station
    if @station != @route.stations_list.last
      station = @route.stations_list.index(@station)
      @station = @route.stations_list[station + 1]
    end
  end

  def to_back_station
    if @station != @route.stations_list.first
      station = @route.stations_list.index(@station)
      @station = @route.stations_list[station - 1]
    end
  end

  def previous_station
    if !@route.nil?
      station = @route.stations_list.index(@station)
      if station != 0
        @previous_station = @route.stations_list[station - 1]
      else
        @previous_station = @route.stations_list[station]
      end
    end
  end

  def next_station
    if !@route.nil?
      station = @route.stations_list.index(@station)
      if (station + 1) != @route.stations_list.length
        @next_station = @route.stations_list[station + 1]
      else
        @next_station = @route.stations_list[station]
      end
    end
  end
end
