class AddPermalinkToCommonTagsTags < ActiveRecord::Migration
  def up
    CommonTags::Tag.all.each do |tag|
      tag.update_attribute :permalink, tag.name.parameterize
    end
    add_column :common_tags_tags, :permalink, :string, index: { unique: true }
  end

  def down
    remove_column :common_tags_tags, :permalink
  end
end
