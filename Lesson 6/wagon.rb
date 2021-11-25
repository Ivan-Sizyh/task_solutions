require_relative 'modules/manufacturer.rb'
require_relative 'modules/validation_method.rb'

class Wagon
  include Manufacturer
  include  Validate

  attr_reader :type

  def initialize
    @type
  end

end