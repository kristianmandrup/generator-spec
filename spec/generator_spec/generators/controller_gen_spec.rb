require 'spec_helper' 

RSpec::Generator::Require.root_dir = 'generator_spec/fixtures'

puts "root_dir: #{RSpec::Generator::Require.root_dir}"

RSpec::Generator.debug = true

require_generator :controller

describe 'helper_generator' do  
  use_helpers :controller #, :special  
  
  before do
    create_rails_app
  end
  
  after do
    remove_rails_app
  end
  
  before :each do              
    setup_generator :controller do
      tests ControllerGenerator
    end    
    remove_controller :account    
  end
  
  after :each do              
    remove_controller :account    
  end

  it "should have created temporary Rails app with a Gemfile" do
    # read_gem_file.should_not be_empty
  end          
    
  it "should not work without an Account controller file" do
    with_generator do |g|   
      g.run_generator :account.args
      g.should_not generate_controller :account
    end
  end
  
  it "should decorate an existing Account controller file with a 'control_me' method" do            
    with_generator do |g|  
      create_controller :account do
        '# controller content'
      end    
      g.run_generator :account.args
      g.should generate_controller :account do |content|
        content.should have_method :control_me
      end
    end
  end
end
