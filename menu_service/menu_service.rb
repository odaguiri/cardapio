require 'roda'
require 'puma'

module MenuService
  class App < Roda
    plugin :json, classes: [Array, Hash, Sequel::Model]
    plugin :all_verbs
    plugin :typecast_params

    route do |r|
      r.put 'menus', Integer do |id|
        menu = Menu.first(id: id)
        menu.update(r.params)
        response.headers['Location'] = "/menu/#{menu.id}"
        menu
      end

      r.delete 'menus', Integer do |id|
        Menu.first(id: id).delete
        response.status = 204
        response.finish
      end

      r.on 'menus' do
        r.get do
          Menu.all
        end

        r.post do
          menu = Menu.create(r.params)
          response.headers['Location'] = "/menu/#{menu.id}"
          menu
        end
      end
    end
  end
end