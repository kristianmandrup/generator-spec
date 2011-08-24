require 'rails/all'
require 'active_support/inflector'
require 'rails/generators'
require 'rails/generators/test_case'
require 'generator-spec/rspec/generator/configure'

module RSpec::Generator
  class << self    
    attr_accessor :generator, :test_method_name, :remove_temp_dir, :debug, :logger, :logfile

    def debug?
      debug
    end

    def info msg
      Rails.logger.info(msg) if debug?
    end      

    def remove_rails_dir!
      FileUtils.rm_rf ::TmpRails.root
    end

    def run_generator *args, &block
      generator.run_generator *args
      if block
        block.arity < 1 ? generator.instance_eval(&block) : block.call(generator, self)  
      end      
    end

    def with_generator &block
      with(get_generator, &block)
    end

    def setup_generator test_method_name, &block
      info "-----------------------------------------------------"
      info "#{Time.now} -- setup generator: [#{test_method_name}]"            
      clean! if test_method_name                                                              
      generator = get_generator(test_method_name) #.extend(Rails::Assist::Generators::BasicHelper)
      if block
        block.arity < 1 ? generator.class.instance_eval(&block) : block.call(generator.class)  
      end
    end
    
    protected

    def with(generator, &block)
      if block
        block.arity < 1 ? generator.instance_eval(&block) : block.call(generator, self, generator.class)  
      end
    end
    
    def clean!
      if generator
        generator.class.generator_class = nil 
      end
      @generator = nil
    end
  
    def get_generator test_method_name=nil
      @generator ||= RSpec::Generator::TestCase.new(test_method_name.to_s.underscore + '_spec')
    end
    
  end # class self
end