module RSpec::RailsApp::ArtifactFile  
  module Matchers    
    ::RailsAssist.artifacts.each do |name|
      class_eval %{
        alias_method :generate_#{name}_file, :have_#{name}_file
      }
    end
  end
end   

