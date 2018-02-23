class RemoveTagConnections < ActiveRecord::Migration
  def change
    remove_column :common_tags_tags, :tag_connections_count
    drop_table :common_tags_tag_connections
  end
end
