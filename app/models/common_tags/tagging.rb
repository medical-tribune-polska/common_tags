module CommonTags
  class Tagging < ActiveRecord::Base
    belongs_to :tag, class_name: 'CommonTags::Tag'
    belongs_to :taggable, polymorphic: true

    validates :tag_id, uniqueness: { scope: :taggable }

    after_save :add_connected_tags

    def add_connected_tags
      taggable.tags << tag.connected_tags - taggable.tags
    end
  end
end