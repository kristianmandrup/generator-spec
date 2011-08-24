# require the generators
def require_generators *generator_list     
  req = RSpec::Generator::Require
  generator_list.each do |name, generators|
    case name
    when Hash
      req.parse_generator_hash name      
    when Symbol
      req.require_all_generators and return if name == :all
      if !generators || generators.empty?
        req.require_generator! name
      else
        req.parse_generator_list name, generators  
      end
    else
      raise ArgumentError, "required generator(s) must be stated either using a symbol or array of symbols"      
    end
  end
end  
alias :require_generator :require_generators

module RSpec::Generator
  module Require
    class << self
      attr_accessor :lib, :root_dir

      def debug?
        RSpec::Generator.debug?
      end
      
      def parse_generator_hash hash
        parse_generator_list hash.keys.first, hash.values.flatten
      end

      def parse_generator_list name, generators           
        if generators.empty?                       
          require_generator! name          
        else  
          generators.each do |generator_name|
            require_generator! name, generator_name
          end  
        end  
      end

      def require_all_generators name=nil
        raise Error, "lib must be set to lib directory for RSpec::Generator::Require" if !lib
        base_path = File.join(lib, 'generators')
        path = name ? File.join(base_path, name) : base_path
        path = File.expand_path path
        root = root_dir || ''
        path = File.join(root, path)                
        puts "require_all: #{path}" if debug?
        require_all path
      end

      def require_generator! name, generator=nil  
        require_all_generators(name) and return if generator == :all        

        file = (require_file_name name, generator)
        file.gsub! /^\//, ''
        puts "Loading generator: #{file}" if debug?
        require file
      end

      def require_file_name name, name_space=nil
        root = root_dir || ''
        file = File.join('generators', name.to_s, "#{name_space}", "#{name_space || name}_generator")
        File.join(root, file)
      end
    end
  end
end