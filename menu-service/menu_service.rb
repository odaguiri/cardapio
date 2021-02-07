require_relative 'models'

require 'roda'

module MenuService
  class App < Roda
    route do |r|
      r.root { 'Menu Service' }
    end
  end
end