module RSpec::Generator  
  def self.configure &block
    conf = RSpec::Generator::Configure
    if block
      block.arity < 1 ? conf.instance_eval(&block) : block.call(conf, self)  
    end      
  end
  
  module Configure
    class << self
      def remove_temp_dir= bool
        RSpec::Generator.remove_temp_dir = bool
      end  
      
      def debug= bool
        RSpec::Generator.debug = bool
      end

      def default_rails_root path, options = {} 
        configure_root_dir path, options
      end

      def rails_root= path, options = {} 
        configure_root_dir path, :custom
      end

      def lib= path
        RSpec::Generator::Require.lib = path
      end

      def logger= type
        case type
        when Symbol          
          raise ArgumentError, "Unknown logger type #{type}" if ![:stdout, :file].include?(type)            
          RSpec::Generator.logger = type
        when Hash
          RSpec::Generator.logger = type
        else 
          raise ArgumentError, "Unknown logger type #{type.inspect}, must be set as Symbol :stdout, :file or Hash (for advanced configuration)"
        end        
      end

      protected

      def configure_root_dir path, options = {}
        ::Rails.application.configure do
          config.root_dir = options == :custom ? TmpRails.root_dir(File.dirname(path) + '/../tmp', :custom) : TmpRails.root_dir(path)          
        end

        gen = RSpec::Generator

        ::RSpec.configure do |config|
          config.after(:suite) do
            gen.remove_rails_dir! if gen.remove_temp_dir
          end
        end        

        ::RSpec::Generator::TestCase.destination ::Rails.root      
        ::Rails::Generators.configure!         
      end
    end
  end  # Configure  
end