module Accessors
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym

        define_method(name) {instance_variable_get(var_name).last}

        define_method("#{name}_history") {instance_variable_get(var_name)}

        define_method "#{name}=" do |value|
          array = instance_variable_get(var_name)
          array ||= []
          array << value

          instance_variable_set(var_name, array)
        end
      end
    end

    def strong_attr_accessor(name, value_class)
      var_name = "@#{name}".to_sym
      define_method(name) {instance_variable_get(var_name)}
      define_method("#{name}=") do |value|
        if value.class == value_class
          instance_variable_set(var_name, value)
        else
          raise "Тип значения должен быть #{value_class}!"
        end
      end
    end
  end

  module InstanceMethods
  end
end