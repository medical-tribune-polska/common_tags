class CreateCommonTagsLists < ActiveRecord::Migration
  def up
    create_table :common_tags_lists do |t|
      t.string :name
      t.string :permalink, index: { unique: true }
      t.timestamps
    end

    add_column :common_tags_tags, :list_id, :integer
    add_index :common_tags_tags, :list_id

    execute <<-SQL
      INSERT INTO common_tags_lists (name) VALUES ('podyplomie'), ('magwet');
      UPDATE common_tags_tags
      SET list_id = common_tags_lists.id
      FROM common_tags_lists
      WHERE common_tags_lists.name = 'podyplomie';
    SQL
  end

  def down
    remove_index :common_tags_tags, :list_id
    remove_column :common_tags_tags, :list_id
    drop_table :common_tags_lists
  end
end
