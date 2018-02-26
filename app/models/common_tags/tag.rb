module CommonTags
  class Tag < ActiveRecord::Base
    include HasNameAndPermalink

    has_many :taggings, dependent: :destroy
    belongs_to :list

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
  end
end
