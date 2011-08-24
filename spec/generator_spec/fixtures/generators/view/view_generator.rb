require 'active_support/inflector'
require 'logging_assist'

include Log4r

class ViewGenerator < Rails::Generators::NamedBase
  include RailsAssist::BasicLogger  
  extend RailsAssist::UseMacro

  desc "Adds some view code to existing View" 
    
  argument :view, :type => :string, :required => true
  argument :ext,    :type => :string, :default => 'html.erb'
    
  def self.source_root
    @source_root ||= File.expand_path("../templates", __FILE__)
  end

  def add_helper_method  
    if File.exist?(view_file_name)
      inject_into_file(view_file_name, view_code, :after => after_txt) if after_txt
    else
      say "#{view_file_name} does not exist. Please create it first before you can add view code to it!", :red
    end
  end

  protected

  use_helpers :view

  def after_txt
    '# view content'
  end
                     
  def view_file_name
    File.join(Rails.root, "app/views/#{file_name}/#{view}.#{ext}")
  end

  def view_code
    %Q{
  <%= "Hello You" %>
}
  end
end 
