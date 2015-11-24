class AddMessageToBuilds < ActiveRecord::Migration
  def up
    add_column :builds, :message, :string
  end

  def down
    remove_column :builds, :message
  end
end
