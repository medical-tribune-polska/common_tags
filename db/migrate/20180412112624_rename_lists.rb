class RenameLists < ActiveRecord::Migration
  def change
    rename_table :common_tags_lists, :common_tags_site_groups
    rename_column :common_tags_tags, :list_id, :site_group_id
  end
end
