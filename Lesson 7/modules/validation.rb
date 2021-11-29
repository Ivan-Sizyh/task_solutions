module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods

    def validate(item, type, param = nil)
      item = "@#{item}".to_sym
      validations << {item: item, type: type, param: param}
    end

    def validations
      @validations ||= []
    end

    def validations=(value)
      @validations = validations << value
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue
      false
    end

    protected

    def validate!
      self.class.validations.each do |operation|

        value = instance_variable_get(operation[:item])

        send("validate_#{operation[:type]}", value, operation[:param])
      end
    end

    def validate_presence(value, param)
      raise "Значения атрибута не может быть пустым!" if value.nil? || value.to_s.strip.empty?
    end

    def validate_format(value, param)
      raise "Некоректный формат!" if value !~ param
    end

    def validate_type(value, param)
      raise "Значения атрибута не соответствуют заданному классу!" if value.class != param
    end

    def validate_more_zero(value, param)
      raise "Значения атрибута не может быть меньше либо равно нулю!" if value.to_i <= 0
    end

  end
end
