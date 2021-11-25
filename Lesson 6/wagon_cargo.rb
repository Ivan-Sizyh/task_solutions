class CargoWagon < Wagon

  attr_reader :occupied_volume, :volume

  def initialize(volume)
    @type = "грузовой"
    @volume = volume
    @occupied_volume = 0
    validate!
  end

  def free_volume
    @volume - @occupied_volume
  end

  def fill(volume)
      @occupied_volume += volume if self.free_volume > volume && volume > 0
  end

  protected

  def validate!
    raise "Объем вагона указан некоректно!" if @volume.to_i <= 0
  end

end