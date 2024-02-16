require "logger"
LOGGER = Logger.new($stdout)
LOGGER.level = ENV.fetch("RODA_LOG_LEVEL", "info")

database_url = ENV.fetch("DATABASE_URL") { "sqlite://storage/development.sqlite" }

after_connect = proc do |db|
  db.execute "PRAGMA journal_mode=wal;"
  db.execute "PRAGMA synchronous=normal;"
  db.execute "PRAGMA mmap_size=134217728;"
  db.execute "PRAGMA journal_size_limit=67108864;"
  db.execute "PRAGMA cache_size=2000;"

  db.busy_handler do |count|
    (count <= 100).tap { |result| sleep count * 0.001 if result }
  end
end

require "sequel/core"
DB = Sequel.connect(database_url, logger: LOGGER, after_connect: after_connect)
DB.transaction_mode = :immediate
