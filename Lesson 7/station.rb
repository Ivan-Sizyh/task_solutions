require_relative 'modules/instance_counter.rb'
require_relative 'modules/validation.rb'

class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains, :stations

  validate :name, :presence

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    validate!
    self.register_instance
  end

  def add_train(train)
    @trains << train
  end

  def get_station_trains
    @trains
  end

  def get_cargo_trains
    @trains.filter{|train| train.type == "грузовой"}
  end

  def get_passenger_trains
    @trains.filter{|train| train.type == "пассажирский"}
  end

  def get_train(train)
    @trains.delete(train)
  end

  def operation_with_trains(block)
    self.trains.map { |train| block.call(train) }
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  protected

  attr_writer :name, :trains#Вне классов эти свойства не должны перезаписываться пользователем

end