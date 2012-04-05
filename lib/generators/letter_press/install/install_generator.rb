module LetterPress
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      class_option :test_framework, :type => :string, :aliases => "-t",
                                    :desc => "Test framework to use LetterPress with"

      def blueprints_file
        if rspec?
          copy_file "blueprint.rb", "spec/blueprint.rb"
        else
          copy_file "blueprint.rb", "test/blueprint.rb"
        end
      end

    private

      def rspec?
        options[:test_framework].to_sym == :rspec
      end
    end
  end
end
