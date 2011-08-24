require 'test/unit'

module RSpec::Generator
  class TestCase < ::Rails::Generators::TestCase   
    setup :prepare_destination
          
    def initialize(test_method_name)
      @method_name = test_method_name
      @test_passed = true
      @interrupted = false
      routes_file = File.join(File.dirname(__FILE__), 'routes.rb')        
      copy_routes routes_file
    end 
    
    def copy_routes routes_file        
      routes = File.expand_path(routes_file)
      raise ArgumentError, "No routes file exists at #{routes_file}" if !File.exist?(routes)
      destination = File.join(::Rails.root, "config")
      FileUtils.mkdir_p(destination) # create dir
      FileUtils.cp routes, destination # copy
    end
         
  end
end

