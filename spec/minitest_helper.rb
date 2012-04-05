require 'minitest/autorun'
require 'minitest-colorize'
require "letter_press"

Kernel.instance_eval do
  alias_method :context, :describe
end
