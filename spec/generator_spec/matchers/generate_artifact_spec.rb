require 'spec_helper'
RSpec::Generator::Require.root_dir = 'generator_spec/fixtures'
require_generator :model

describe 'model_generator' do
  use_orm :mongoid

  before do
    setup_generator :model do
      tests ModelGenerator
    end    
  end
  
  before :each do              
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
    create_model :account
       
    with_generator do |g|        
      g.run_generator :account.args
      g.should generate_artifact :account, :model
            
      g.should generate_model :account do |content|
        content.should include_module 'Canable::Ables'
      end
      
      g.should_not generate_model :user
      g.should_not generate_controller :user            
    end
  end
  
  it "should not have generated other things!" do            
    with_generator do |g|        
      g.should_not generate_model :user
      g.should_not generate_controller :user      
    end
  end
end