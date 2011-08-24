module RSpec::RailsApp::ArtifactFile  
  module Matchers    
    alias_method :generate_artifact_files, :have_rails_artifact_files
    
    ::RailsAssist.artifacts.each do |name|
      class_eval %{
        alias_method :generate_#{name}_files, :have_#{name}_files
      }
    end
  end
end   

