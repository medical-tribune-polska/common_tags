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
        joins <<-SQL
          INNER JOIN (
            SELECT DISTINCT(taggable_id)
            FROM common_tags_taggings
            WHERE common_tags_taggings.taggable_type = '#{name}'
            AND common_tags_taggings.tag_id IN ('#{tag_ids.join("','")}')
          ) selected_taggings
          ON #{table_name}.id = selected_taggings.taggable_id
        SQL
      }
    end
  end
end
