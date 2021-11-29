require_relative 'modules/manufacturer.rb'
require_relative 'modules/validation.rb'

class Wagon
  include Manufacturer
  include Validation

  attr_reader :type

  def initialize
    @type
  end

end