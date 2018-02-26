class CreateCommonTagsLists < ActiveRecord::Migration
  def up
    create_table :common_tags_lists do |t|
      t.string :name
      t.string :permalink, index: { unique: true }
      t.timestamps
    end

    add_reference :common_tags_tags, :list

    podyplomie_list = CommonTags::List.create name: 'podyplomie'
    CommonTags::List.create name: 'magwet'
    CommonTags::Tag.update_all list_id: podyplomie_list.id
  end

  def down
    remove_reference :common_tags_tags, :list
    drop_table :common_tags_lists
  end
end
