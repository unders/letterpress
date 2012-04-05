require 'minitest_helper'

describe LetterPress::Ghost do
  before do
    def Object.next; 1; end
    @ghost = LetterPress::Ghost.new(Object)
  end

  describe "#keys" do
    it "returns a collection of all messages sent to the object" do
      @ghost.title { 'block' }
      @ghost.body { 'block' }
      @ghost.keys.must_equal [:title, :body]
    end
  end

  describe "#sn" do
    it "returns a serial number" do
      @ghost.sn.must_equal 1
    end
  end

  describe "a message with a block is sent to the object" do
    it "creates a method that returns the content of the block" do
      @ghost.title { 'I am a block' }
      @ghost.title.must_equal 'I am a block'
    end

    it "doesn't execute the code inside the block until the method is called" do
      def Object.counter; @counter ||= 0; @counter +=1; end
      @ghost.title { Object.counter }
      @ghost.title.must_equal 1
      @ghost.title.must_equal 2
    end
  end

  describe "a message is sent with a block containing a string with \#{sn}" do
    it "interporlates the sn number" do
      @ghost.town { "I am ghost town number-#{sn}" }
      @ghost.town.must_equal "I am ghost town number-1"
    end
  end
end
