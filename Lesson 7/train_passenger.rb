class PassengerTrain < Train

  validate :number, :format, NUMBER_FORMAT
  validate :number, :presence

  def initialize(number)
    super(number)
    @type = "пассажирский"
    validate!
  end

end