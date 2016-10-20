module CommonTags
  class Tag < ActiveRecord::Base
    has_many :tag_connections, dependent: :destroy
    has_many :connected_tags, class_name: Tag, through: :tag_connections
    has_many :taggings, dependent: :destroy

    before_validation :downcase_name, if: :name_changed?

    validates :name, presence: true, allow_blank: false
    validates :name, uniqueness: true

    scope :specialization, -> { where specialization: true }

    def publish_create
      Publisher.publish action: 'create',
                        attributes: as_json(methods: :connected_tag_ids)
    end

    def publish_update(changed_attributes)
      Publisher.publish action: 'update', attributes: changed_attributes, id: id
    end

    def publish_destroy
      Publisher.publish action: 'destroy', id: id
    end

    def related_tags_for_select
      Tag.where.not(id: id).order(:name)
    end

    private

      def attributes_with_connected_tag_ids
        attributes.merge connected_tag_ids: connected_tag_ids
      end

      def downcase_name
        self.name = name.downcase
      end
  end
end
