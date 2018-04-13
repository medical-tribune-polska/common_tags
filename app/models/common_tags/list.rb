module CommonTags
  class List < ActiveRecord::Base
    include HasNameAndPermalink

    validates :name, uniqueness: { case_sensitive: false, scope: 'site_group_id' }
    validates :permalink, uniqueness: { scope: 'site_group_id' }

    has_and_belongs_to_many :tags
    belongs_to :site_group

    def to_param
      permalink
    end
  end
end
