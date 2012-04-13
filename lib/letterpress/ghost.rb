module Letterpress
  class Ghost
    def initialize(serial_number)
      @serial_number = serial_number
    end

    def sn
      @serial_number.next
    end

    def keys
      @keys ||= []
    end

    def method_missing(method, *args, &block)
      if block_given?
        keys << method
        m = Module.new do
          define_method(method, &block)
        end
        extend m
      else
        super
      end
    end
  end
end
