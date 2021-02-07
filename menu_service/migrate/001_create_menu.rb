class CreateMenu < Sequel::Migration
  def up
    create_table :menus do
      primary_key :id
      char :title , null: false, size: 100
      text :description, null: false
    end
  end

  def down
    drop_table :menu
  end
end