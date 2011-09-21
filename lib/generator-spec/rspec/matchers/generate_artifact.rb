module RSpec::RailsApp::Artifact
  module Matchers
    class GenerateArtifact < HaveArtifact
      def initialize(name, artifact_type)
        super name, artifact_type
      end

      def matches? generator, &block
        root = Rails.root # File.join(Rails.application.config.root_dir, 'rails_app')   
        super root, &block
      end
    end

    def generate_artifact name, type
      GenerateArtifact.new name, type
    end

    (::RailsAssist.artifacts - [:view]).each do |name|
      plural_artifact = name.to_s.pluralize
      class_eval %{
        def generate_#{name} name
          generate_artifact name, :#{name}
        end
      }
    end

    def generate_view folder, action=nil, view_ext=nil
      arg = {:folder => folder, :action => action, :view_ext => view_ext}
      generate_artifact arg, :view
    end
  end
end

