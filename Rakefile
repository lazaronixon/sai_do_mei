require_relative "models"

task :server do |t|
	sh "puma -C ./config/puma.rb"
end

namespace :db do
  task :migrate do
    Sequel.extension :migration
    Sequel::Migrator.run DB, "migration"
  end

  task :seed do
    require_relative "db/seed.rb"
  end
end
