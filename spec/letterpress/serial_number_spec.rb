require 'minitest_helper'
describe Letterpress::SerialNumber do
  before do
    @serial_number = Letterpress::SerialNumber.new
  end

  describe "#next" do
    describe "when called the first time" do
      it "returns 1" do
        @serial_number.next.must_equal 1
      end
    end

    describe "when called the second time" do
      it "returns the consecutive number" do
        number = @serial_number.next
        @serial_number.next.must_equal (number + 1)
      end
    end
  end
end
