module CommonTags
  class TagConnection < ActiveRecord::Base
    belongs_to :tag, counter_cache: true
    belongs_to :connected_tag, class_name: Tag

    validates :tag_id, uniqueness: { scope: :connected_tag_id }

    after_create :add_connected_tag_to_tag_taggables

    def add_connected_tag_to_tag_taggables
      return unless tag && connected_tag

      tag.taggings.each do |tagging|
        tagging.taggable.tags << connected_tag
      end
    end
  end
end
