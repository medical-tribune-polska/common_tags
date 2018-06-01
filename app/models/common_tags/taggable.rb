module CommonTags
  module Taggable
    extend ActiveSupport::Concern

    included do
      has_many :tags, through: :taggings, class_name: 'CommonTags::Tag'
      has_many :taggings,
               as: :taggable,
               class_name: 'CommonTags::Tagging',
               dependent: :destroy

      scope :with_tags, lambda { |tag_ids|
        joins(:taggings)
          .where 'common_tags_taggings.tag_id IN (?)', tag_ids
      }
    end
  end
end
