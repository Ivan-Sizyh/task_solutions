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
    def validate!
      self.class.validations.each do |operation|

        value = instance_variable_get(operation[:item])

        case operation[:type]
        when :format
          raise "Некоректный формат!" if value !~ operation[:param]
        when :type
          raise "Значения атрибута не соответствуют заданному классу!" if value.class != operation[:param]
        when :presence
          raise "Значения атрибута не может быть пустым!" if value.nil? || value.to_s.strip.empty?
        when :more_zero
          raise "Значения атрибута не может быть меньше либо равно нулю!" if value.to_i <= 0
        else
          next
        end
      end
    end

    def valid?
      validate!
      true
    rescue
      false
    end
  end
end
