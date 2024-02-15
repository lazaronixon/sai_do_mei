require_relative "db"
require "sequel/model"

dev = ENV.fetch("RODA_ENV", "development") == "development"

Sequel.inflections do |inflect|
  inflect.plural(/ao$/i,  "oes")
  inflect.singular(/oes$/i, 'ao')
end

Sequel::Model.cache_associations     = false if dev
Sequel::Model.typecast_on_assignment = false

Sequel::Model.plugin :require_valid_schema
Sequel::Model.plugin :subclasses unless dev

Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :timestamps
Sequel::Model.plugin :enum

unless defined?(Unreloader)
  require "rack/unreloader"
  Unreloader = Rack::Unreloader.new(reload: false, autoload: !ENV["NO_AUTOLOAD"])
end

Unreloader.autoload("models") { |f| Sequel::Model.send(:camelize, File.basename(f).sub(/\.rb\z/, "")) }
