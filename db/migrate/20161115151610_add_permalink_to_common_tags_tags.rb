class AddPermalinkToCommonTagsTags < ActiveRecord::Migration
  def change
    add_column :common_tags_tags, :permalink, :string, index: { unique: true }

    reversible do |dir|
      dir.up do
        CommonTags::Tag.all.each do |tag|
          tag.update_attribute :permalink, tag.name.parameterize
        end
      end
    end
  end
end
