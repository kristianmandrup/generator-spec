require 'active_support/inflector'
require 'logging_assist'

include Log4r

class ObserverGenerator < Rails::Generators::NamedBase
  include RailsAssist::BasicLogger  
  extend RailsAssist::UseMacro
  
  desc "Adds method 'observe_me' to a Observer" 
    
  def self.source_root
    @source_root ||= File.expand_path("../templates", __FILE__)
  end

  def add_observer_method  
    if File.exist?(observer_file_name)
      inject_into_file(observer_file_name, observer_method_code, :after => after_txt) if after_txt
    else
      say "#{observer_file_name} does not exist. Please create it first before you can add a observer method to it!", :red
    end
  end

  protected 
  
  use_helpers :observer

  def after_txt
    "ActiveRecord::Observer"
  end
                     
  def observer_file_name
    File.join(Rails.root, "app/models/#{file_name}_observer.rb")
  end

  def observer_method_code
    %Q{
  def observe_me
    "Observe me please!"
  end
}
  end
end 
