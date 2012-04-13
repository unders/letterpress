# Letterpress [![Build Status](http://travis-ci.org/unders/letterpress.png)](http://travis-ci.org/unders/letterpress)

Letterpress is a _lightweight_ model generator that replaces fixture files.


## Installation

Add this line to your application's Gemfile:

    gem 'letterpress'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install letterpress

## Usage

### Rails, ActiveRecord and minitest


1. Update Gemfile

        group :development, :test do
          gem 'letterpress', :require => 'letterpress/rails'
        end

2. Install the gem

        $ bundle install

3. Generate (test|spec)/blueprint.rb file

        $ rails generate letterpress:install

4. Update config/application.rb

        config.generators do |g|
          g.test_framework :mini_test, :spec => true, :fixture_replacement => :letterpress
        end

5. Generate a model object with its factory

        $ rails generate model Comment post_id:integer body:text

6. It adds to the end of file (test|spec)/blueprint.rb

        class Comment < Blueprint(ProxyMethods)
          default do
            post_id { 1 }
            body { "MyText" }
          end
        end

7. Modify the generated blueprint according to your preferences

        class Comment < Blueprint(ProxyMethods)
          default do
            post { Post.make.new }
            body { "MyText" }
          end
        end

8. Write tests in test/comment_test.rb

        require "minitest_helper"

        class CommentTest < MiniTest::Rails::Model
          before do
            @comment = Comment.make.new
          end

          it "must be valid" do
            @comment.valid?.must_equal true
          end
        end



Compatibility
-------------

Ruby version 1.9.2 and 1.9.3 and Rails version 3.1

[GemTesters](http://test.rubygems.org/gems/letterpress) has
 more information on which platforms Letterpress is tested.
 

Test
-------------------------

    gem install rubygems-test
    gem test letterpress


For more info see: [GemTesters](http://test.rubygems.org/)

Where
-----
* [Letterpress @ Github](http://github.com/unders/letterpress)
* [Letterpress @ GemTesters](http://test.rubygems.org/gems/letterpress)
* [Letterpress @ Rubygems](http://rubygems.org/gems/letterpress)
* [Letterpress @ Rubydoc](http://rubydoc.info/gems/letterpress)
* [Letterpress @ Travis](http://travis-ci.org/#!/unders/letterpress)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
