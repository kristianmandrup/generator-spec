require 'spec_helper'

RSpec::Generator::Require.root_dir = 'generator_spec/fixtures'

require_generator :observer

describe 'observer_generator' do 
  use_helper :observer  
     
  before :each do              
    setup_generator 'observer_generator' do
      tests ObserverGenerator
    end    
    remove_observer :account    
  end

  after :each do              
    remove_observer :account    
  end
    
  it "should not work without an Account observer file" do            
    with_generator do |g|   
      g.run_generator :account.args
      g.should_not generate_observer :account
    end
  end

  it "should decorate an existing Account observer file with a 'observe_me' method" do            
    with_generator do |g|  
      create_observer :account do
        '# observer content'
      end    
      g.run_generator :account.args
      g.should generate_observer_file :account do |content|        
        content.should have_observer_class :account do |klass|
          klass.should have_method :observe_me
        end
      end
    end
  end
end
