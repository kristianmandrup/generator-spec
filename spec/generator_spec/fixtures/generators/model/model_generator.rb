require 'active_support/inflector'
require 'logging_assist'

include Log4r

class ModelGenerator < Rails::Generators::NamedBase  
  desc "Adds Canable::Ables permission system to Model" 

  # argument :name, :type => :string, :default => 'User', :desc => 'Name of model to make Canable:Able', :required => false

  # class_option :user_stamps, :type => :boolean, :default => false 
  
    
  def make_canable_able  
    begin
      logger.debug "make_canable_able: #{name}"
      insert_into_model name do
        canable_include_txt
      end
    rescue
      say "model #{name} does not exist. Please create it first before you can make it Canable:Able", :red
    end
  end

  def post_log
    say "Your model #{name.to_s.camelize} is now Canable:Able. Please define your permissions in the model", :green
  end

  protected

  include RailsAssist::BasicLogger
  
  extend RailsAssist::UseMacro
  use_orm   :mongoid
  # use_helper :model

  def canable_include_txt
    %Q{
  include Canable::Ables
  #{add_userstamps}

  # permission logic
  #{add_methods}
}
  end

  def add_userstamps 
    "userstamps! # adds creator and updater\n" # if options[:userstamps]
  end

  def add_methods
    methods = []
    %w{creatable destroyable updatable viewable}.each do |name|
      # if !has_method?(name)
        method = add_method(name)
        methods << method if method
      # end
    end
    methods.join("\n  ")
  end

  def add_method(name)        
    #if options[name.to_sym]
    %Q{
  def #{name}_by?(user)
    true
  end}     
    #end
  end      
end 
