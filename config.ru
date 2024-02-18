dev = ENV.fetch("RODA_ENV", "development") == "development"

require "logger"
logger = dev ? Logger.new($stdout) : nil

require "rack/unreloader"
Unreloader = Rack::Unreloader.new(subclasses: %w"Roda Sequel::Model", reload: dev, autoload: true, logger: logger) { App }
require_relative "models"
Unreloader.require("app.rb") { "App" }
run(dev ? Unreloader : App.freeze.app)

RubyVM::YJIT.enable if defined? RubyVM::YJIT.enable
