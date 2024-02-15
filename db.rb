# require "extralite"
# Extralite.on_progress do |busy|
#   sleep 1 * 0.001 if busy
# end
#

require "logger"
LOGGER = Logger.new($stdout)
LOGGER.level = ENV.fetch("RODA_LOG_LEVEL", "info")

require "sequel/core"
DB = Sequel.connect(ENV.fetch("DATABASE_URL") { "extralite://storage/development.sqlite" })
DB.loggers << LOGGER
