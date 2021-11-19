class Station
  attr_reader :name, :trains
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
    @trains.filter{|train| train.type == "грузовой"}
  end

  def get_passenger_trains
    @trains.filter{|train| train.type == "пассажирский"}
  end

  def get_train(train)
    @trains.delete(train)
  end

  protected

  attr_writer :name, :trains #Вне классов эти свойства не должны перезаписываться пользователем

end