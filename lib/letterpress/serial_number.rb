module Letterpress
  class SerialNumber
    def next
      @next ||=0
      @next += 1
    end
  end
end

