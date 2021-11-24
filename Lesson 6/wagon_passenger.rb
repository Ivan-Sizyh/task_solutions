class PassengerWagon < Wagon

  attr_reader :seats, :taken_seats

  def initialize(seats)
    @type = "пассажирский"
    @seats = seats
    @taken_seats = 0
    validate!
  end

  def take_wagon_seat
    @taken_seats += 1 if empty_seats_count
  end

  def empty_seats_count
    @seats - @taken_seats
  end

  protected

  def validate!
    raise "Количество мест в вагоне указано некоректно!" if @seats.to_i <= 0
  end

end