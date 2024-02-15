dev = ENV.fetch("RODA_ENV", "development") == "development"

require "rack/unreloader"
Unreloader = Rack::Unreloader.new(subclasses: %w"Roda Sequel::Model", reload: dev, autoload: false) { App }
require_relative "models"
Unreloader.require("app.rb") { "App" }
run(dev ? Unreloader : App.freeze.app)

RubyVM::YJIT.enable if defined? RubyVM::YJIT.enable
