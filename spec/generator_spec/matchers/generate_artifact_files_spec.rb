require 'spec_helper'
RSpec::Generator::Require.root_dir = 'generator_spec/fixtures'

require_generator :model

describe 'model_generator' do
  use_orm     :mongoid

  before :each do
    setup_generator 'model_generator' do
      tests ModelGenerator
    end
    remove_models :account, :person
  end

  after :each do
    remove_models :account, :person
  end

  it "should not work without an Account model file" do
    with_generator do |g|
      g.run_generator :account.args
      g.should_not generate_model_files :account, :person
    end
  end

  it "should decorate an existing Account model file with include Canable:Ables" do
    with_generator do |g|
      create_model :account
      create_model :person
      g.run_generator :account.args
      g.run_generator :person.args
      g.should generate_artifact_files :model, :account, :person
      g.should generate_model_files :account, :person
    end
  end
end
