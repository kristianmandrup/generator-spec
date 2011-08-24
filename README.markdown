# RSpec 2 add-on for specifying and testing generators

This project contains RSpec 2 matchers, helpers and various utilities to assist in writing Generator specs. 
There is additional support for writing specs for Generators in Rails 3.

## Why?

Rails 3 has a Rails::Generators::TestCase class for use with Test-Unit, to help test generators. This TestCase contains specific custom assertion methods that can be used to assert generator behavior. To create an RSpec 2 equivalent, I wrapped Rails::Generators::TestCase for use with RSpec 2 and created some RSpec 2 matchers that mimic the assertion methods of the Test-Unit TestCase. I have also a bunch of "extra goodies" to the mix. 

This RSpec DSL should make it very easy and enjoyable to spec and test your Generators with RSpec 2 :)

## Feedback

Please let me know if you find any issues or have suggestions for improvements. 

## Install

<code>gem install generator-spec</code>

The gem is a jewel based on [jeweler](http://github.com/technicalpickles/jeweler). 
To install the gem from the code, simply use the jeweler rake task:

<code>rake install</code>

## Usage

The following demonstrates usage of this library. There are many more options and DSL convenience methods (see wiki, code or specs).

### Configuration

First setup the *spec_helper.rb*. Here is an example configuration.

<pre># spec/spec_helper.rb
  
require 'rspec'
require 'generator-spec'

# configure it like this to use default settings
RSpec::Generator.configure do |config|
  config.debug = false
  config.remove_temp_dir = true
  config.default_rails_root(__FILE__)
  config.logger = :stdout # :file to output to a log file, logger only active when debug is true
end

# or customize the location of the temporary Rails 3 app dir used
RSpec::Generator.configure do |config|
  # ...
  config.rails_root = '~/my/rails/folder'
end

</pre>

### Specs for generators

I recommend having a separate spec file for each generator (generator specs).
You can use the special *require_generator* statement to ensure that one or more generators are loaded and made available for a given spec.

<pre>require_generator :canable</pre>

This will load the generator : `generators/canabale_generator.rb`

If the generator is in a namespace (subfolder of generators), use a nested approach like this:

<pre>require_generators :canable => ['model', 'user']</pre>

This will load the generators: `generators/canable/model_generator.rb` and `generators/canable/user_generator.rb`

You can also load generators from multiple namespaces and mix and match like this. 
I recommend against this however as it is difficult to read.

<pre>require_generators [:canable => ['model', 'user'], :other => :side, :simple]</pre>

### Auto-require all generators

You can also require all generators or all within a specific namespace like this:

require_generators :all
require_generators :canable => :all

### Example: full generator spec

<pre># spec/generators/model_generator_spec.rb  

require 'spec_helper'

# list of generators to spec are loaded
require_generator :canable

describe 'model_generator' do
  # include Rails model helpers for ActiveRecord
  # available: 

  # Other ORM options - :mongo_mapper, :mongoid and :data_mapper
  # note: use_orm auto-includes the :model helper module
  use_orm :active_record
  
  # load helper modules and make available inside spec blocks
  # here the module in rails_helpers/rails_migration is included 
  # to load multiple helpers use the method -  use_helpers
  use_helper :migration
  
  before :each do              
    # define generator to test
    setup_generator 'model_generator' do
      tests Canable::Generators::ModelGenerator
    end    
    # ensure clean state before each run
    remove_model :account
  end

  after :each do              
    # ensure clean state after each run  
    remove_model :account
  end

  describe "the weird stuff!!!" do
    before :each do
      @generator = with_generator do |g|   
        g.run_generator :account.args
      end
    end
    
    it "should not work without an existing Account model file" do            
      @generator.should_not generate_file :account, :model
    end
  end
    
  it "should not work without an existing Account model file" do            
    with_generator do |g|   
      g.run_generator :account.args
      g.should_not generate_file :account, :model
    end
  end

  it "should decorate an existing Account model file with 'include Canable:Ables'" do            
    with_generator do |g|  
      create_model :account     
      g.run_generator 'account'.args
      g.should generate_model :account do |content|
        content.should have_class :account do |klass|
          klass.should include_module 'Canable::Ables'
        end
      end
    end
  end
end</pre>

## Code specs 

There are a bunch of specialized ruby code matchers in the matchers/content folder which can be used to spec code files in general.
Check out the specs in spec/generator_spec/matchers/content for examples on how to use these. 

## Rails specs

The rails_helpers folder contains a bunch of files which makes it easy to spec rails files and to perform various "Rails mutations". 
These mutations make it easy to setup the temporary Rails app in a specific pre-condition, which is required for a given spec.

### Examples: Rails helpers

require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe 'controller' do
  include RSpec::Rails::Controller 

  before :each do              
    create_controller :account do
      %q{
        def index
        end
      }
    end    
  end

  after :each do              
    remove_controller :account
  end
    
  it "should have an account_controller file that contains an AccountController class with an index method inside" do      
    Rails.application.should have_controller :account do |controller_file|
      controller_file.should have_controller_class :account do |klass|
        klass.should have_method :index
      end
    end
  end
end


## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Kristian Mandrup. See LICENSE for details.
