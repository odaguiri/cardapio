require_relative 'db'

require 'logger'
require 'sequel'

module MenuService
  Model = Class.new(Sequel::Model)
  Model.db = DB
  Model.plugin :subclasses
  Model.plugin :prepared_statements
  Model.plugin :pg_auto_constraint_validations
  Model.plugin :json_serializer
  Model.plugin :timestamps, update_on_create: true
  if ENV['RACK_ENV'] = 'test'
    Model.plugin :forbid_lazy_load
    Model.plugin :instance_specific_default, :warn
  end

  %w'menu'.each { |x| require_relative "models/#{x}" }
  Model.freeze_descendents
  DB.freeze
end