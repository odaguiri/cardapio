dev = ENV['RACK_ENV'] == 'development'
require 'rack/unreloader'
Unreloader = Rack::Unreloader.new(subclasses: %w'Roda Sequel::Model', reload: dev) { MenuService::App }
Unreloader.require './models.rb'
# Unreloader.require('models') { |f| File.basename(f).sub(/\.rb\z/, '').capitalize }
Unreloader.require './menu_service.rb'

run(dev ? Unreloader : MenuService::App)