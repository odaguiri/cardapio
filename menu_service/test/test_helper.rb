ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/hooks/default'
require 'rack/test'
require 'byebug'

require_relative '../models'
require_relative '../menu_service'

class Minitest::HooksSpec
  around(:all) do |&block|
    MenuService::DB.transaction(rollback: :always) { super(&block) }
  end

  around do |&block|
    MenuService::DB.transaction(rollback: :always, savepoint: true) { super(&block) }
  end
end