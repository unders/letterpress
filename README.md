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

    ``` ruby
    group :development, :test do
      gem 'letterpress', :require => 'letterpress/rails'
    end
    ```

2. Install the gem

        $ bundle install

3. Generate (test|spec)/blueprint.rb file


        $ rails generate letterpress:install
        

4. Update config/application.rb

    ``` ruby
    config.generators do |g|
      g.test_framework :mini_test, :spec => true, :fixture_replacement => :letterpress
    end
    ```

5. Generate a model object with its factory

        $ rails generate model Comment post_id:integer body:text

6. It adds to the end of file (test|spec)/blueprint.rb

    ``` ruby
    class Comment < Blueprint(ProxyMethods)
      default do
        post_id { 1 }
        body { "MyText" }
      end
    end
    ```

7. Modify the generated blueprint according to your preferences

    ``` ruby
    class Comment < Blueprint(ProxyMethods)
      default do
        post { Post.make.new }
        body { "MyText" }
      end
    end
    ```

8. Write tests in test/comment_test.rb

    ``` ruby
    require "minitest_helper"

    class CommentTest < MiniTest::Rails::Model
      before do
        @comment = Comment.make.new
      end

      it "must be valid" do
        @comment.valid?.must_equal true
      end
    end
    ```


## Blueprint Class
A blueprint for a model is defined inside the Letterpress module; the class name of the blueprint
__must__ be the same as the models class name. 

Below is an example of a Letterpress User class. Letterpress has two methods for 
defining blueprints: `default` and `define`; `default` can be used once in each 
class but `define` can be used as many time as you like. In this example 
the `admin` attribute is overridden by the admin block. The admin block will inherit 
the other attributes defined inside the default block. 


```ruby
module Letterpress
  class User < Blueprint(ProxyMethods)
    default do
      email { "user@example.com" }
      admin { false }
    end

    define(:admin) do
      admin { true }
    end
  end
end

user = User.make
user.admin # => false
user.email # => "user@example.com"

user = User.make(:admin)
user.admin # => true
user.email # => "user@example.com"

user = User.make(:admin, admin: false)
user.admin # => false
user.email # => "user@example.com"
```

#### Unique Attributes
For attributes that must be unique, you can call the `sn` method within the 
attribute block to get a unique serial number for the object.

```ruby
email { "user-#{sn}@example.com" }

user1 = User.make
user2 = User.make

user1.email # => "user1@example.com"
user2.email # => "user2@example.com"
```

#### What you must know to create a blueprint class:
* The class methods `default` and `define` is used for defining default attribute values.
* An attribute values __must__ be defined inside a block: `{}`. 
* The `sn` method is used inside an attribute block to create unique attribute values, e.g if 
  each user instance must have a unique email address.

## Creating Object
Letterpress ads [`make`](https://github.com/unders/letterpress/blob/master/lib/letterpress.rb#L12) 
to each ActiveRecord class; When `make` is called on an ActiveRecord class, it returns a proxy object 
that will [delegate](https://github.com/unders/letterpress/blob/master/lib/letterpress/blueprint.rb#L73) 
its received messages to the ActiveRecord instance.


[The proxy object](https://github.com/unders/letterpress/blob/master/lib/letterpress.rb#L18) implements these methods:
* [`new`](https://github.com/unders/letterpress/blob/master/spec/letterpress/rails_spec.rb#L86) - returns the object under test or raises an exception if the object isn't valid.
* [`new!`](https://github.com/unders/letterpress/blob/master/spec/letterpress/rails_spec.rb#L108) - returns the object under test, even if not valid.
* [`save`](https://github.com/unders/letterpress/blob/master/spec/letterpress/rails_spec.rb#L128) - returns the persisted object under test or raises an exception if the object isn't valid.


```ruby
User.make # Returns instance of Letterpress::User
User.make(:admin) # Returns instance of Letterpress::User
User.make(:admin, email: "foo@bar.com") # Returns instance of Letterpress::User


User.make.new # Returns the User instance
User.make(:admin).save # Returns the User instance
User.make(:admin, email: "foo@bar.com").new! # Returns the User instance
```

## Creating global ProxyMethods
Since each Letterpress class inherits from 
[ProxyMethods](https://github.com/unders/letterpress/blob/master/lib/letterpress.rb#L18), 
we can define methods in that module and they will be added to each proxy object.

In the code snippet below I have added a `save_and_relod` method that will be 
available on every proxy object.

```ruby
module Letterpress
  module ProxyMethods
    def save_and_reload
      record = save
      @object = @object.class.find(record.id)
    end
  end
end

user = User.make.save_and_reload
```

## Creating ProxyMethods on a class
If you want to add a method to only one proxy object, see code below.

```ruby
module Letterpress
  class User < Blueprint(ProxyMethods)
    default do
      #...
    end

    def password(password)
      @object.password = "#{password} - in proxy" 
      @object
    end
  end
end

user = User.make.password("secret").save
user.password # => "secret - in proxy"
```

## Overriding .make
If you for some reason want to do something with the proxy object before returning it, you can 
do that, see code below.

```ruby
module Letterpress
  class User < Blueprint(ProxyMethods)
    default do
      #...
    end

    def self.make
     user = super
     # do something with the proxy object before returning it
     user.password =  "I always have this value"
     user
    end
  end
end

user = User.make.new
user.password # => "I always have this value"
```

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
