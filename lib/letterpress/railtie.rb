module Letterpress
  class Railtie < Rails::Railtie
    config.after_initialize do
      blueprints = [ File.join(Rails.root, 'test', 'blueprint'),
                     File.join(Rails.root, 'spec', 'support', 'blueprint')]
       blueprints.each do |path|
         if File.exists?("#{path}.rb")
           load("#{path}.rb")
           break
         end
      end
    end
  end
end
