module CommonTags
  class Tag < ActiveRecord::Base
    has_many :tag_connections, dependent: :destroy
    has_many :connected_tags, class_name: Tag, through: :tag_connections
    has_many :taggings, dependent: :destroy

    before_validation :set_default_permalink, if: :permalink_blank?

    validates :name, presence: true, allow_blank: false
    validates :name, uniqueness: { case_sensitive: false }

    validates :permalink, presence: true, allow_blank: false
    validates :permalink, uniqueness: true

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

    def to_suggest
      { id: id,
        text: name,
        specialization: specialization?,
        count: tag_connections_count }
    end

    private

      def attributes_with_connected_tag_ids
        attributes.merge connected_tag_ids: connected_tag_ids
      end

      def permalink_blank?
        permalink.blank?
      end

      def set_default_permalink
        self.permalink = name.parameterize
      end
  end
end
