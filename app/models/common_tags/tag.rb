module CommonTags
  class Tag < ActiveRecord::Base
    include HasNameAndPermalink

    validates :name, uniqueness: { case_sensitive: false, scope: 'list_id' }
    validates :permalink, uniqueness: { scope: 'list_id' }

    has_many :taggings, dependent: :destroy
    belongs_to :list

    scope :specialization, -> { where specialization: true }

    def publish_create
      Publisher.publish action: 'create', attributes: as_json
    end

    def publish_update(changed_attributes)
      Publisher.publish action: 'update', attributes: as_json
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
  end
end
