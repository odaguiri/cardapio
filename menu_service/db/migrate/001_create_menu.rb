class CreateMenu < Sequel::Migration
  def up
    create_table :menus do
      primary_key :id
      String :title , null: false, size: 100
      String :description, null: false, text: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end

  def down
    drop_table :menu
  end
end