module CommonTags
  class Tagging < ActiveRecord::Base
    belongs_to :tag, class_name: 'CommonTags::Tag'
    belongs_to :taggable, polymorphic: true

    validates :tag_id, uniqueness: { scope: :taggable_id }
  end
end
