require 'minitest/autorun'
require 'minitest-colorize'
require "letterpress"

Kernel.instance_eval do
  alias_method :context, :describe
end
