class AddAnotherRepoToBuilds < ActiveRecord::Migration
  def up
    remove_column :builds, :repository
    remove_column :builds, :pr_url
    add_column :builds, :base_repository, :string
    add_column :builds, :head_repository, :string
  end

  def down
    remove_column :builds, :repository
    remove_column :builds, :pr_url
    add_column :builds, :base_repository, :string
    add_column :builds, :head_repository, :string
  end
end
