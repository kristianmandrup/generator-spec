require 'rails_artifactor'

class ControllerGenerator < Rails::Generators::NamedBase
  desc "Adds method 'control_me' to a Controller" 
    
  def add_helper_method  
    begin
      insert_into_controller name do
        include_txt
      end
    rescue
      say "Controller #{name} does not exist. Please create it first before you can add a controller method to it!", :red
    end
  end

  protected
  
  extend RailsAssist::UseMacro
  use_helpers :controller

  def include_txt
    %{def control_me
    "Control me please!"
  end}
  end

end 
