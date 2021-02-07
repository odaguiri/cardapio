require_relative 'db'

require 'logger'
require 'sequel'

module MenuService
  Model = Class.new(Sequel::Model)
  Model.db = DB
  Model.plugin :subclasses
  Model.plugin :prepared_statements
  Model.plugin :pg_auto_constraint_validations
  if ENV['RACK_ENV'] = 'test'
    Model.plugin :forbid_lazy_load
    Model.plugin :instance_specific_default, :warn
  end

  Model.freeze_descendents
  DB.freeze
end