# encoding: utf-8
require 'minitest_helper'

module LetterPress
  module Admin
    class User < Blueprint; end
  end
  class User < Blueprint; end
  class Comment < Blueprint; end
end

class User
  extend LetterPress
  attr_accessor :name
  def self.counter; @counter; end
  def self.counter=(c); @counter = c; end
  def initialize; self.class.counter = 0; end
  def save; self.class.counter += 1; end
end

class Comment
  extend LetterPress
  attr_accessor :user
  attr_accessor :body
end

module Admin
  class User
    extend LetterPress
    attr_accessor :name
  end
end

describe LetterPress::Blueprint do
  describe ".make" do
    it "creates an instance" do
      LetterPress::User.make.must_be_instance_of(LetterPress::User)
    end
  end

  describe ".default" do
    before do
      LetterPress::User.default do
        name { "User 1" }
      end
    end

    describe "when called with a block" do
      it "saves the block" do
        LetterPress::User.default.must_equal :name => 'User 1'
      end
    end

    describe "when called without a block" do
      it "returns a hash" do
        LetterPress::User.default.must_equal :name => 'User 1'
      end
    end
  end

  describe ".define" do
    before do
      LetterPress::Comment.define(:admin) do
        user { LetterPress::User.make(:name => 'Anders Admin').new }
      end
    end

    describe "when called with a block" do
      it "creates a class method specified by the symbol name" do
        LetterPress::Comment.admin[:user].name.must_equal 'Anders Admin'
      end

      it "saves the block" do
        LetterPress::Comment.admin[:user].name.must_equal 'Anders Admin'
      end
    end

    describe "when called without a block" do
      it "returns a hash" do
        LetterPress::Comment.admin[:user].name.must_equal 'Anders Admin'
      end
    end
  end

  describe "when the default block values is used" do
    before do
      LetterPress::Comment.default do
        user { User.make(:name => 'Anders Default').new }
        body { 'I am defined in default' }
      end
      LetterPress::Comment.define(:spam) do
        user { User.make(:name => 'Anders Spam').new }
      end
    end

    describe "when .define(:spam) has not defined the method in its block" do
      it "returns the body defined in the default block" do
        LetterPress::Comment.spam[:body].must_equal 'I am defined in default'
      end
    end
    describe "when .define(:spam) has defined the method in its block" do
      it "returns the value from the spam block" do
        LetterPress::Comment.spam[:user].name.must_equal 'Anders Spam'
      end
    end
  end

  describe "serial number interpolation with sn method" do
    before do
      LetterPress::User.default do
        name { "User #{sn}" }
      end
      LetterPress::User.define(:admin) do
        name { "Admin #{sn}" }
      end
    end

    it "returns the next number for each hash" do
      LetterPress::User.admin[:name].must_equal "Admin 1"
      LetterPress::User.default[:name].must_equal "User 2"
      LetterPress::User.default[:name].must_equal "User 3"
      LetterPress::User.admin[:name].must_equal "Admin 4"
    end
  end

  describe "#new" do
    before do
      LetterPress::User.default do
        name { 'Anders' }
      end
    end
    it "returns the correct object" do
      LetterPress::User.make.new.must_be_instance_of(User)
    end

    it "populates the returned object with the defined values" do
      LetterPress::User.make.new.name.must_equal 'Anders'
    end
  end

  describe "when a message is sent to the instance" do
    before do
      LetterPress::User.default do
        name { 'Anders' }
      end
    end
    it "delegates that message" do
      LetterPress::User.make.save.must_equal 1
    end
  end

  describe "blocks are not executed when defined" do
    before do
      LetterPress::User.default do
        name { 'Anders' }
      end
      LetterPress::Comment.default do
        user { User.make.save }
      end
    end

    it "executes the defined block when its method is called" do
      LetterPress::Comment.default
      User.counter.must_equal  1
    end
  end

  describe "can handle classes within a module namespace" do
    before do
      LetterPress::Admin::User.default do
        name { "Anders is admin" }
      end
    end

    it "returns the correct object populated with the default values" do
      user = Admin::User.make.new
      user.must_be_instance_of(Admin::User)
      user.name.must_equal "Anders is admin"
    end
  end
end
