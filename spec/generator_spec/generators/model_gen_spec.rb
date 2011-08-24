require 'spec_helper'

RSpec::Generator::Require.root_dir = 'generator_spec/fixtures'

require_generator :model

describe 'model_generator' do
  use_orm     :mongoid
  # use_helper  :model
  
  before :each do              
    setup_generator 'model_generator' do
      tests ModelGenerator
    end    
    remove_model :account    
  end

  after :each do              
    remove_model :account    
  end
    
  it "should not work without an Account model file" do            
    with_generator do |g|   
      g.run_generator :account.args
      g.should_not generate_model :account
    end
  end

  it "should decorate an existing Account model file with include Canable:Ables" do            
    with_generator do |g|  
      create_model :account     
      g.run_generator :account.args
      g.should generate_model :account do |content|
        content.should include_module 'Canable::Ables'
      end
    end
  end
end