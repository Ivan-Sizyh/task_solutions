require_relative 'modules/manufacturer.rb'

class Wagon
  include Manufacturer

  attr_reader :type

  def initialize
    @type
  end

end