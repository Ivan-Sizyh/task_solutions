class CargoTrain < Train

  def initialize(number)
    super(number)
    @type = "грузовой"
  end

  def add_wagon(wagon)
    super(wagon) if wagon.type == "грузовой"
  end

end