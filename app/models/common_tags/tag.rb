module CommonTags
  class Tag < ActiveRecord::Base
    has_many :taggings, dependent: :destroy

    before_validation :set_default_permalink, if: :permalink_blank?

    validates :name, presence: true, allow_blank: false
    validates :name, uniqueness: { case_sensitive: false }

    validates :permalink, presence: true, allow_blank: false
    validates :permalink, uniqueness: true

    scope :specialization, -> { where specialization: true }

    def publish_create
      Publisher.publish action: 'create', attributes: as_json
    end

    def publish_update(changed_attributes)
      Publisher.publish action: 'update', attributes: changed_attributes, id: id
    end

    def publish_destroy
      Publisher.publish action: 'destroy', id: id
    end

    def to_suggest
      {
        id: id,
        text: name,
        specialization: specialization?
      }
    end

    private

      def permalink_blank?
        permalink.blank?
      end

      def set_default_permalink
        self.permalink = name.parameterize
      end
  end
end
