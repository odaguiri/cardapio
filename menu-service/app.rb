require "roda"

class App < Roda
  route do |r|
    r.root { "Menu Service" }
  end
end