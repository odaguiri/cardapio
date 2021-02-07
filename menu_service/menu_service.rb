require 'roda'
require 'puma'

module MenuService
  class App < Roda
    plugin :json, classes: [Array, Hash, Sequel::Model]

    route do |r|
      r.root { { banana: :ok } }
    end
  end
end