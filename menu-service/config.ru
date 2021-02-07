require_relative 'menu_service'
require 'puma'

run MenuService::App.freeze.app