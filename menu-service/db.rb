require 'sequel/core'

module MenuService
  DB = Sequel.connect(ENV['RACK_ENV'] == 'test' ? 'postgres://cardapio:cardapio@db:5472/cardapio_test' : ENV.delete('DATABASE_URL'))
end