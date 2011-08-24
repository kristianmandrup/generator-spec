module RSpec::Generator
  module Macro  
    def with_generator &block
      RSpec::Generator.with_generator &block
    end

    def setup_generator test_method_name=nil, &block
      RSpec::Generator.setup_generator test_method_name, &block
    end 
    
    def create_rails_app app_name = nil
      app_name ||= 'rails_app'
      Dir.mkdir ::TmpRails.root if !File.directory?(::TmpRails.root)
      Dir.chdir ::TmpRails.root do
        FileUtils.rm_rf app_name
        %x[rails new #{app_name} --force]
      end
    end

    def remove_rails_app app_name = nil
      app_name ||= 'rails_app'
      Dir.mkdir ::TmpRails.root if !File.directory?(::TmpRails.root)
      Dir.chdir ::TmpRails.root do      
        FileUtils.rm_rf app_name
      end
    end    
  end
end

module RSpec::Core
  class ExampleGroup
    extend RSpec::Generator::Macro
  end
end

