class CreateCommonTagsLists < ActiveRecord::Migration
  def up
    create_table :common_tags_lists do |t|
      t.string :name
      t.string :permalink, index: { unique: true }
      t.timestamps
    end

    add_column :common_tags_tags, :list_id, :integer
    add_index :common_tags_tags, :list_id

    podyplomie_list = CommonTags::List.create name: 'podyplomie'
    CommonTags::List.create name: 'magwet'
    CommonTags::Tag.update_all list_id: podyplomie_list.id
  end

  def down
    remove_index :common_tags_tags, :list_id
    remove_column :common_tags_tags, :list_id
    drop_table :common_tags_lists
  end
end
