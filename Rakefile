require_relative "models"

task :server do |t|
	sh "bundle exec falcon serve -b http://0.0.0.0:3000"
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
