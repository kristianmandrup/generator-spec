require 'generator-spec/rspec/macro'

RSpec.configure do |config|
  config.extend RSpec::Generator::Macro
  config.include RSpec::Generator::Macro
end