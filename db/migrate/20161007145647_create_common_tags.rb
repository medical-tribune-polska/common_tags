class CreateCommonTags < ActiveRecord::Migration
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'
    execute 'CREATE TABLE common_tags_tags (id uuid PRIMARY KEY DEFAULT uuid_generate_v4());'

    change_table :common_tags_tags do |t|
      t.string :name, null: false
      t.boolean :specialization, default: false
      t.integer :tag_connections_count

      t.timestamps
    end
    add_index :common_tags_tags, :name, unique: true

    create_table :common_tags_taggings do |t|
      t.references :taggable, polymorphic: true, index: true
    end
    add_column :common_tags_taggings, :tag_id, :uuid

    add_index :common_tags_taggings,
              [:tag_id, :taggable_id, :taggable_type],
              unique: true,
              name: 'index_common_tags_taggings_on_tag_and_taggable'

    create_table :common_tags_tag_connections
    add_column :common_tags_tag_connections, :connected_tag_id, :uuid
    add_column :common_tags_tag_connections, :tag_id, :uuid

    add_index :common_tags_tag_connections,
              [:tag_id, :connected_tag_id],
              unique: true,
              name: 'index_common_tags_tag_connections_on_tag_ids'
  end

  def down
    drop_table :common_tags_tags
    drop_table :common_tags_taggings
    drop_table :common_tags_tag_connections

    execute 'DROP EXTENSION IF EXISTS "uuid-ossp"'
  end
end
