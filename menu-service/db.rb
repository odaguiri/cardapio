require 'sequel/core'
# require 'sqlite3' if ENV['RACK_ENV'] == 'test'

module MenuService
  DB = Sequel.connect(ENV.delete('DATABASE_URL'))
end
