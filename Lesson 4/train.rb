require_relative 'modules/manufacturer.rb'
require_relative 'modules/instance_counter.rb'

class Train
  attr_reader :speed, :number, :station, :route, :wagons_list, :type

  include Manufacturer
  include InstanceCounter

  @@trains = []

  def self.find(number)
    @@trains.find{|train| train.number == number}
  end

  def initialize(number)
    @number = number
    @speed = 0
    @wagons_list = []
    @@trains << self
    self.register_instance
  end

  def speed=(speed)
    if speed > 0
      @speed = speed
    end
  end

  def stop
    @speed = 0
  end

  def train_stop?
    @speed.zero?
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
    if self.route
      station = @route.stations_list.index(@station)
      if (station + 1) != @route.stations_list.length
        @route.stations_list[station + 1]
      end
    end
  end

  def add_wagon(wagon)
    if train_stop?
      case wagon.type
      when "грузовой"
        @wagons_list << wagon
      when "пассажирский"
        @wagons_list << wagon
      else

      end
    end
  end

  def remove_wagon(wagon)
    if train_stop? && @wagons_list.any?
      @wagons_list.delete(wagon)
    end
  end

  protected

  attr_writer :station, :type #Пользователь не должен напрямую указывать параметр
  attr_accessor :trains
end