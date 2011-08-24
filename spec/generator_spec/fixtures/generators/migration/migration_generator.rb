require 'migration_assist'

class MigrationGenerator < Rails::Generators::NamedBase
  include RailsAssist::Migration

  desc "Creates a migration"

  source_root File.dirname(__FILE__) + '/templates'
      
  def create_migration     
    migration(name, 'create_users')
  end
end 
