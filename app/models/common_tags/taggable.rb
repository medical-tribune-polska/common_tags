module CommonTags
  module Taggable
    extend ActiveSupport::Concern

    included do
      has_many :tags, through: :taggings, class_name: 'CommonTags::Tag'
      has_many :taggings,
               as: :taggable,
               class_name: 'CommonTags::Tagging',
               dependent: :destroy

      scope :with_any_tag, lambda { |tag_ids|
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

      scope :with_tags, lambda { |tag_ids|
        joins(tag_ids.map { |tag_id| CommonTags::Taggable.join_statement(tag_id, name, table_name) }.join)
      }
    end

    def self.join_statement(tag_id, name, table_name)
      unique_join_name = SecureRandom.hex
      <<-SQL
        INNER JOIN (
          SELECT DISTINCT(taggable_id)
          FROM common_tags_taggings
          WHERE common_tags_taggings.taggable_type = '#{name}'
          AND common_tags_taggings.tag_id = '#{tag_id}'
        ) selected_#{unique_join_name}
        ON #{table_name}.id = selected_#{unique_join_name}.taggable_id
      SQL
    end
  end
end
