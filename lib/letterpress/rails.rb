require 'letterpress'
require 'letterpress/railtie'

ActiveRecord::Base.extend(Letterpress)
