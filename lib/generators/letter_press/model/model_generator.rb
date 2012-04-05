module LetterPress
  module Generators
    class ModelGenerator < Rails::Generators::NamedBase
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      def create_blueprint
        file_name = if File.exists?(File.join(Rails.root, 'test', 'blueprint.rb'))
          "test/blueprint.rb"
        elsif File.exists?(File.join(Rails.root, 'spec', 'blueprint.rb'))
          "spec/blueprint.rb"
        else
          raise "Cannot find the blueprint file"
        end
        gsub_file(file_name, /.end\s*\Z/mx) { |match| "#{code}\n#{match}" }
      end

    private

      def code
      %Q{\n
  class #{class_name} < Blueprint(ProxyMethods)
    default do
      #{attributes.map { |a| "#{a.name} { #{a.default.inspect} }" }.join("\n      ")}
    end
  end}
      end
    end
  end
end
