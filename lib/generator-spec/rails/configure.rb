module TmpRails
  class << self
    attr_accessor :root

    def root_dir path, options = {}
      @root = options == :custom ? custom_root_dir(path) : default_root_dir(path)
    end

    protected

    def default_root_dir path
      File.expand_path(File.join(File.dirname(path), '..', 'tmp'))
    end

    def custom_root_dir path
      File.expand_path(path)
    end
  end
end

module Rails
  def self.root
    @root ||= File.join(Rails.application.config.root_dir, 'rails_app')
  end
end

class TestApp < Rails::Application
end

Rails.application = TestApp 

module Rails
  def self.logger
    logger_type = RSpec::Generator.logger
    case logger_type
    when Hash
      file = logger_type[:file]
    when :stdout
      return Logger.new(STDOUT)
    when :file
      file = File.expand_path "#{Rails.application.config.root_dir}/../rails_generator.log"
    else
      return Logger.new(STDOUT)
    end
    if file != @logger_file
      @logger_file = file
      RSpec::Generator.logfile = file 
      @logger = Logger.new(file) if file
    else
      @logger ||= Logger.new(file) if file
    end
  end
end

