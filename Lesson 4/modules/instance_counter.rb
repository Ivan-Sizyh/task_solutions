module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :counter

    def instances
      counter ? counter : 0
    end
  end

  module InstanceMethods

    protected

    def register_instance
      self.class.counter = self.class.instances + 1
    end
  end
end