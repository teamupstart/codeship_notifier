class CreateBuilds < ActiveRecord::Migration
  create_table "builds" do |t|
    t.string  "repository"
    t.string  "commit"
    t.string  "build_url"
    t.string  "pr_url"
    t.string  "last_status"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "builds", ["commit"], :name => "index_builds_commit"
end
