module RSpec::RailsApp::Artifact
  module Matchers
    class GenerateArtifacts < HaveArtifacts
      def initialize(artifact_type, *names)
        super
      end

      def matches?(generator, &block)
        root = Rails.root # File.join(Rails.application.config.root_dir, 'rails_app'), &block
        super root
      end
    end

    def generate_artifacts type, *names
      GenerateArtifacts.new type, *names
    end

    (::RailsAssist.artifacts - [:view]).each do |name|
      plural_artifact = name.to_s.pluralize
      class_eval %{
        def generate_#{plural_artifact} *names
          generate_artifacts :#{name}, *names
        end
      }
    end

    def generate_views folder, *args
      generate_artifacts folder, *args
    end
  end
end

