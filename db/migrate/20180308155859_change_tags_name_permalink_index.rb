class ChangeTagsNamePermalinkIndex < ActiveRecord::Migration
  def change
    remove_index :common_tags_tags, column: :name

    add_index :common_tags_tags, [:name, :list_id]
    add_index :common_tags_tags, [:permalink, :list_id]
  end
end
