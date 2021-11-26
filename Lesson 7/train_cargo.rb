class CargoTrain < Train

  validate :number, :format, NUMBER_FORMAT
  validate :number, :presence

  def initialize(number)
    super(number)
    @type = "грузовой"
    validate!
  end

end