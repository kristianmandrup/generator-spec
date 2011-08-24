require 'rails_artifactor'

class HelperGenerator < Rails::Generators::NamedBase
  include RailsAssist::Artifact::Helper

  desc "Adds method 'help_me' to a Helper" 
    
  def add_method  
    begin
      insert_into_helper name do
        %{def help_me
  "Help me please!"
end}
      end
    rescue
      say "Helper #{name} does not exist. Please create it!", :red
    end
  end

end 
