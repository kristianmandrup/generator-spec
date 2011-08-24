require 'rspec'
require 'generator-spec'

RSpec::Generator.configure do |config|
  config.debug = true
  config.remove_temp_dir = false # true #false
  config.default_rails_root(__FILE__) 
  config.lib = File.dirname(__FILE__) + '/../lib'
  config.logger = :file
end
   