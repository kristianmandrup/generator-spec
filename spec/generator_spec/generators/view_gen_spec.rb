require 'spec_helper'

RSpec::Generator::Require.root_dir = 'generator_spec/fixtures'

require_generator :view

describe 'view_generator' do  
  use_helper :view  

  before :each do              
    setup_generator 'view_generator' do
      tests ViewGenerator
    end    
    remove_view :account, :edit
  end

  after :each do              
    remove_view :account, :edit
  end
    
  it "should not work without an Edit Account view file" do            
    with_generator do |g|   
      g.run_generator [:account, :edit, 'html.erb'].args
      g.should_not generate_view :account, :edit
    end
  end

  it "should decorate an existing Edit Account view file with some view code" do            
    with_generator do |g|  
      create_view :account, :edit do
        '# view content'
      end    
      g.run_generator [:account, :edit, 'html.erb'].args
      g.should generate_view :account, :edit do |file|
        file.should match /Hello You/
      end
    end
  end
end



