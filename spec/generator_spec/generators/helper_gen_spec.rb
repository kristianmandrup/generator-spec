require 'spec_helper'

# RSpec::Generator.debug = true
RSpec::Generator::Require.root_dir = 'generator_spec/fixtures'

require_generator :helper

describe 'helper_generator' do  
  use_helper :helper
  
  before :each do              
    setup_generator 'helper_generator' do
      tests HelperGenerator
    end    
    remove_helper :account    
  end

  after :each do              
    remove_helper :account    
  end
    
  it "should not work without an Account helper file" do            
    with_generator do |g|
      g.run_generator :account.args
      g.should_not generate_helper :account
    end
  end

  it "should decorate an existing Account helper file with a 'help_me' method" do
    with_generator do |g|  
      create_helper :account do
        '# helper content'
      end    
      g.run_generator :account.args
      g.should generate_helper :account do |content|
        content.should have_method :help_me
      end
    end
  end
end



