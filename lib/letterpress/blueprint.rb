require 'letterpress/serial_number'
require 'letterpress/ghost'

module Letterpress
  class Blueprint; end

  class << Blueprint
    def make(*args)
      new(*args)
    end

    def default(options={}, &block)
      if block_given?
        ghosts[:default] = Ghost.new(serial_number).instance_eval(&block)
      else
        hash = options.merge({})
        default = ghosts[:default]
        (default.keys - options.keys).each do |key|
          hash[key] = default.send(key)
        end
        hash
      end
    end

    def define(method, &block)
      ghosts[method] = Ghost.new(serial_number).instance_eval(&block)
      self.class.send(:define_method, method) do |options={}|
        hash = options.merge({})
        blueprint = ghosts[method]
        blueprint_keys = blueprint.keys
        (blueprint_keys - options.keys).each do |key|
          hash[key] = blueprint.send(key)
        end

        default = ghosts.fetch(:default, {})
        (default.keys - blueprint_keys).each do |key|
          hash[key] = default.send(key)
        end

        hash
      end
    end

  private

    def ghosts
      @ghosts ||={}
    end

    def serial_number
      @serial_number ||= SerialNumber.new
    end
  end

  class Blueprint
    def initialize(*args)
      symbol = args.first.is_a?(Symbol) ? args.first : :default
      options = args.last.is_a?(Hash) ? args.pop : {}
      klass_names = self.class.name.sub('Letterpress::', '').split('::')
      @object = klass_names.inject(Kernel) do |klass_level, name|
        klass_level.const_get(name)
      end.new

      self.class.send(symbol, options).each do |key, value|
        @object.send("#{key}=", value)
      end
    end

    def new
      @object
    end

    def method_missing(method, *args, &block)
      @object.send(method, *args, &block)
    end

    def respond_to_missing?(method, *)
      @object.respond_to?(method)
    end
  end
end
