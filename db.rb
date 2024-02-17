require "logger"
LOGGER = Logger.new($stdout)
LOGGER.level = ENV.fetch("RODA_LOG_LEVEL", "info")

database_url = ENV.fetch("DATABASE_URL") { "extralite://storage/development.sqlite" }

after_connect = proc do |db|
  db.pragma(journal_mode: :wal)
  db.pragma(synchronous: :normal)
  db.pragma(journal_size_limit: 67108864)
  db.pragma(mmap_size: 134217728)
  db.pragma(cache_size: 2000)
  db.busy_timeout = 9999
end

require "sequel/core"
DB = Sequel.connect(database_url, logger: LOGGER, after_connect: after_connect)
