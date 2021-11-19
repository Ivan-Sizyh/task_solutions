class PassengerTrain < Train

  def initialize(number)
    super(number)
    @type = "пассажирский"
  end

  def add_wagon(wagon)
    super(wagon) if wagon.type == "пассажирский"
  end
end