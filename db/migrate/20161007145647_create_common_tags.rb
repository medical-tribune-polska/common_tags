class CreateCommonTags < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :common_tags_tags, id: :uuid do |t|
      t.string :name, null: false
      t.boolean :specialization, default: false
      t.integer :tag_connections_count

      t.timestamps null: false
    end

    add_index :common_tags_tags, :name, unique: true

    create_table :common_tags_taggings do |t|
      t.references :tag, type: :uuid, index: true
      t.references :taggable, polymorphic: true, index: true
    end

    add_index :common_tags_taggings,
              [:tag_id, :taggable_id, :taggable_type],
              unique: true,
              name: 'index_common_tags_taggings_on_tag_and_taggable'

    create_table :common_tags_tag_connections do |t|
      t.references :tag, type: :uuid
      t.references :connected_tag, type: :uuid
    end

    add_index :common_tags_tag_connections,
              [:tag_id, :connected_tag_id],
              unique: true,
              name: 'index_common_tags_tag_connections_on_tag_ids'
  end
end
